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
                go = { "golangcilint", "codespell" },
                javascript = { "codespell" },
                lua = { "codespell" },
                -- markdown = { "markdownlint" },
                ruby = { "rubocop", "reek", "flog", "codespell" },
                vue = { "codespell" },
            },
            linters = {
                rubocop = {
                    args = {
                        "--format",
                        "json",
                        "-S",
                        "--force-exclusion",
                        "--server",
                        "--stdin",
                        function() return vim.api.nvim_buf_get_name(0) end,
                    },
                },
                golangcilint = {
                    args = { "run", "--out-format", "json", "-c", vim.g.home_dir .. "/" .. "dotfiles/go/.golangci.yml" },
                },
                reek = require("plugins.linting.reek"),
                flog = require("plugins.linting.flog"),
            },
        },
        config = function(_, opts)
            local loop = vim.loop
            local lint = require("lint")

            for name, linter in pairs(opts.linters) do
                if type(linter) == "table" and type(lint.linters[name]) == "table" then
                    lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
                else
                    lint.linters[name] = linter
                end
            end
            lint.linters_by_ft = opts.linters_by_ft

            local timer = assert(loop.new_timer())
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("Lint", { clear = true }),
                callback = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    timer:stop()
                    timer:start(
                        1000,
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
