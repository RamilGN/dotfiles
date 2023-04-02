local f = require("functions")

-- Autosave
local autosave = vim.api.nvim_create_augroup("Autosave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = function()
        local curbuf = vim.api.nvim_get_current_buf()

        if not vim.api.nvim_buf_get_option(curbuf, "modified") or
            vim.fn.getbufvar(curbuf, "&modifiable") == 0 or
            f.vim.get_buf_byte_size(curbuf) > vim.g.max_byte_size then
            return
        end

        vim.cmd([[silent! update]])
    end,
    pattern = "*",
    group = autosave
})

-- Turn off input method outside insert mode
local input = vim.api.nvim_create_augroup("InputMode", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        vim.opt.iminsert = 0
    end,
    pattern = "*",
    group = input
})

-- Turn off comments auto-insert
local formatoptions = vim.api.nvim_create_augroup("Formatoptions", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
    pattern = "*",
    group = formatoptions
})

-- Highlight yanking text
local yhlgroup = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    pattern = "*",
    group = yhlgroup,
})

-- Trim trailing whitespaces
local trimspaces = vim.api.nvim_create_augroup("TrimWhitespaces", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = trimspaces,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Open dir at nvim startup
local nvimtree = vim.api.nvim_create_augroup("NvimTree", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if not directory then
            return
        end
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
    end,
    pattern = "*",
    group = nvimtree
})
