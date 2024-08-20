local M = {}

M.system = function(cmd, opts)
    local on_stderr = nil
    if opts.on_stderr ~= nil then
        on_stderr = function(_, d, _)
            opts.on_stderr(vim.inspect(d))
        end
    else
        on_stderr = function(_, d, _)
            vim.notify(d, vim.log.levels.ERROR)
        end
    end

    local cwd = vim.F.if_nil(opts.cwd, vim.loop.cwd())

    vim.fn.jobstart(cmd, {
        -- cwd = cwd,
        on_stdout = function(_, d, _)
            opts.on_stdout(vim.inspect(d))
        end,
        on_stderr = on_stderr,
        stderr_buffered = true,
        stdout_buffered = true,
    })
end

return M
