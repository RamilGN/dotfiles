return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = "ConformInfo",
        keys = require("config.keymaps").formatting(),
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        opts = {
            formatters = {
                injected = { options = { ignore_errors = false } },
                gofumpt = { prepend_args = { "-extra" } },
                pg_format = { prepend_args = { "-L" } },
            },
            formatters_by_ft = {
                go = { "goimports", "gofumpt", "golines" },
                javascript = { "prettierd" },
                lua = { "stylua" },
                markdown = { "markdownlint" },
                ruby = { "rubocop" },
                sql = { "pg_format" },
                vue = {},
            },
        },
    },
}
