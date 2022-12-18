local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

-- Autosave
local autosave = vim.api.nvim_create_augroup("Autosave", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = function()
        local curbuf = api.nvim_get_current_buf()
        if not api.nvim_buf_get_option(curbuf, "modified") then
            return
        end
        cmd([[silent! update]])
    end,
    pattern = "*",
    group = autosave
})

-- Turn off input method outside insert mode
local input = vim.api.nvim_create_augroup("InputMode", { clear = true })
api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        vim.opt.iminsert = 0
    end,
    pattern = "*",
    group = input
})

-- ## Turn off commets auto-insert
local formatoptions = vim.api.nvim_create_augroup("Formatoptions", { clear = true })
api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
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

-- Default behavior for `Enter` in qf
local qf = vim.api.nvim_create_augroup("Quickfix", { clear = true })
api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
    end,
    pattern = { "quickfix" },
    group = qf
})

-- Git 72 char rule
local gclc = vim.api.nvim_create_augroup("GitColorcolumn", { clear = true })
api.nvim_create_autocmd("BufEnter", {
    callback = function()
        opt.colorcolumn = "72"
    end,
    pattern = { "COMMIT_EDITMSG" },
    group = gclc
})
