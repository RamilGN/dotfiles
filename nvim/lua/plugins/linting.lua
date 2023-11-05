return {
    {
        "mfussenegger/nvim-lint",
        event = "BufReadPost",
        opts = {
            events = { "BufReadPost" },
            ft = {
                "go",
                "markdown",
                "ruby",
                "javascript",
                "lua",
            },
            linters_by_ft = {
                markdown = { "markdownlint" },
                lua = { "codespell" },
                ruby = { "rubocop", "codespell" },
                go = { "golangcilint", "codespell" },
                javascript = { "codespell" },
            },
            linters = {},
        },
        config = function(_, opts)
            local loop = vim.loop
            local lint = require("lint")
            lint.linters_by_ft = opts.linters_by_ft
            for k, v in pairs(opts.linters) do
                lint.linters[k] = v
            end

            local timer = assert(loop.new_timer())
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("Lint", { clear = true }),
                callback = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    timer:stop()
                    timer:start(
                        500,
                        0,
                        vim.schedule_wrap(function()
                            if vim.api.nvim_buf_is_valid(bufnr) then
                                vim.api.nvim_buf_call(bufnr, function()
                                    lint.try_lint(nil, { ignore_errors = true })
                                end)
                            end
                        end)
                    )
                end,
            })
        end,
    },
}
