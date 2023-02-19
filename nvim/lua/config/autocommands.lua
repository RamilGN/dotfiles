local f = require("functions")

Autocommands = {
    last_save = 0
}

-- Autosave
local autosave = vim.api.nvim_create_augroup("Autosave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = function()
        local curbuf = vim.api.nvim_get_current_buf()
        local curtime = os.time()
        if curtime - Autocommands.last_save <= 1 then
            return
        end

        if not vim.api.nvim_buf_get_option(curbuf, "modified") or
            vim.fn.getbufvar(curbuf, "&modifiable") == 0 or
            f.vim.get_buf_byte_size(curbuf) > vim.g.max_byte_size then
            return
        end

        vim.cmd([[silent! update]])
        Autocommands.last_save = curtime
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
