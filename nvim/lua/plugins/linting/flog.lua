return {
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
}
