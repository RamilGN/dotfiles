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
                go = { "goimports", "gofumpt", "golines", "codespell" },
                javascript = { "prettierd", "codespell" },
                lua = { "stylua", "codespell" },
                markdown = { "markdownlint" },
                ruby = { "rubocop", "codespell" },
                sql = { "pg_format" },
                vue = { "codespell" },
            },
        },
    },
}
