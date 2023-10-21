local M = {}

M.delta = function(command, opts)
    if opts.delta then
        vim.cmd("term " .. "git --no-pager " .. command .. " | delta --paging=never")
    else
        vim.cmd("term " .. "git --no-pager " .. command)
    end
end

return M
