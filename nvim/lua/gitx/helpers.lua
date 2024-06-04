local M = {}

local Term = require("term")

M.delta = function(command)
    local cmd = "git --no-pager " .. command .. " | delta --paging=never"
    Term.exec(cmd)
end

M.error = function(msg)
    vim.notify(string.format("[gitx]: %s", msg, vim.log.levels.ERROR))
end

return M
