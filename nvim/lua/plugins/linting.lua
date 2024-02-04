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
                    args = { "--format", "json", "--force-exclusion", "-S" },
                },
                reek = {
                    cmd = "reek",
                    args = { "%:p", "--format", "json", "--config", vim.g.home_dir .. "/" .. "dotfiles/ruby/.reek.yml" },
                    ignore_exitcode = true,
                    stdin = false,
                    parser = function(output)
                        local diagnostics = {}
                        local offences = vim.json.decode(output)

                        for _, off in pairs(offences or {}) do
                            local line = off.lines[1] - 1
                            local code = off.smell_type
                            local message = off.message .. "\n" .. off.documentation_link

                            table.insert(diagnostics, {
                                source = "reek",
                                lnum = line,
                                end_lnum = line,
                                col = 0,
                                end_col = 0,
                                severity = vim.diagnostic.severity.HINT,
                                message = message,
                                code = code,
                            })
                        end

                        return diagnostics
                    end,
                },
                flog = {
                    cmd = "flog",
                    args = { "%:p" },
                    ignore_exitcode = true,
                    stdin = false,
                    parser = function(output)
                        local get_scores = function(out)
                            local result = { total_score = 0, all = {} }

                            local lines = {}
                            for line in out:gmatch("([^\n]*)\n?") do
                                table.insert(lines, line)
                            end

                            local total_score = tonumber(lines[1]:match("(%d+%.?%d*): flog total"))
                            result.total_score = total_score

                            for i = 4, #lines, 1 do
                                local line = lines[i]
                                local score, lnum = line:match("(%d+%.%d+).*:(%d*)-")
                                if score == nil then
                                    score = line:match("(%d+%.%d+)")
                                end

                                if lnum == nil then
                                    lnum = 0
                                else
                                    lnum = lnum - 1
                                end

                                if score ~= nil then
                                    table.insert(result.all, { score = tonumber(score), lnum = tonumber(lnum) })
                                end
                            end

                            return result
                        end
                        local scores = get_scores(output)
                        local source = "flog"
                        local critical_total_score = 70
                        local critical_method_score = 20
                        local diagnostics = {}

                        local message = "consider to refactor"
                        local severity = vim.diagnostic.severity.HINT
                        local total_score = scores.total_score

                        if scores.total_score > critical_total_score then
                            table.insert(diagnostics, {
                                source = source,
                                lnum = 0,
                                end_lnum = 0,
                                col = 0,
                                end_col = 0,
                                severity = severity,
                                message = message,
                                code = total_score,
                            })
                        end

                        for _, info in ipairs(scores.all) do
                            local score = info.score

                            if score > critical_method_score then
                                local lnum = (info.lnum or 0)
                                table.insert(diagnostics, {
                                    source = source,
                                    lnum = lnum,
                                    end_lnum = lnum,
                                    col = 0,
                                    end_col = 0,
                                    severity = severity,
                                    message = message,
                                    code = score,
                                })
                            end
                        end

                        return diagnostics
                    end,
                },
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
