vim.lsp.set_log_level("trace")
local client_id = vim.lsp.start({
    name = "my-server-name",
    cmd = { "/home/rami-gaggi/workplace/go/json-rpc2/example/example" },
    root_dir = vim.fs.dirname(vim.fs.find({ "kawa" }, { upward = true })[1]),
})
vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), client_id)
