local sev = vim.diagnostic.severity

return {
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
                severity = sev.HINT,
                message = message,
                code = code,
            })
        end

        return diagnostics
    end,
}
