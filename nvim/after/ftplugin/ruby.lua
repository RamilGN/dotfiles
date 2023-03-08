vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.api.nvim_create_autocmd({ "BufAdd", "BufCreate", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("RubyRemoveSomeIndentKeys", {}),
	pattern = "*.rb",
	callback = function()
		vim.opt_local.indentkeys:remove(".")
		vim.opt_local.indentkeys:remove("{")
		vim.opt_local.indentkeys:remove("}")
	end,
})
