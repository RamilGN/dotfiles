local H = require("gitx.helpers")
local M = {}

---@param filename string
M.log = function(filename)
    local command = string.format("log -p --stat %s", filename)
    H.delta(command)
end

---@param filename string
---@param line1 integer
---@param line2 integer
M.log_range = function(filename, line1, line2)
    local command = string.format("log -p -L%s,%s:%s", line1, line2, filename)
    H.delta(command)
end

M.log_global = function() end

return M
