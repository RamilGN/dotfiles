local M = {}

local H = require("gitx.helpers")

M.show = function(object)
    H.delta("show -p --stat " .. object)
end

M.show_cur_commit = function()
    H.delta("show -p --stat HEAD")
end

return M
