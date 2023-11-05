return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = "ConformInfo",
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = { "n", "v" },
                desc = "Format buffer",
            },
            {
                "<leader>lF",
                function()
                    require("conform").format({ async = true, formatters = { "injected" } })
                end,
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        opts = {
            formatters = {
                injected = { options = { ignore_errors = false } },
                gofumpt = { prepend_args = { "-extra" } },
            },
            formatters_by_ft = {
                go = { "goimports", "gofumpt", "golines", "codespell" },
                javascript = { "prettierd", "codespell" },
                markdown = { "prettierd", "markdownlint" },
                ruby = { "rubocop", "codespell" },
                lua = { "stylua", "codespell" },
                sql = { "pg_format" },
            },
        },
    },
}
