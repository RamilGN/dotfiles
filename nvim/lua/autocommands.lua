local api = vim.api

-- ## Highlight yanking text
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end
})

-- Turn off input method outside insert mode
api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.iminsert = 0
  end
})

-- Default behavior for `Enter` in qf
api.nvim_create_autocmd("BufReadPost", {
  pattern = { "quickfix" },
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
  end
})
