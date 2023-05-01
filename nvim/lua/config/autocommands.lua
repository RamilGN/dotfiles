return {
    setup = function()
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
    end
}
