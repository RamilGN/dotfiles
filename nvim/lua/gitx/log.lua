local H = require("gitx.helpers")

local M = {}

M.log = function(filename)
    local command = string.format("log -p --stat %s", filename)
    H.delta(command)
end

M.log_range = function(filename, line1, line2)
    local command = string.format("log -p -L%s,%s:%s", line1, line2, filename)
    H.delta(command)
end

M.log_global = function(count)
    local command = string.format("log -n %s", count)
    H.exec(command)
end

M.log_global_p = function(count)
    local command = string.format("log -n %s --stat -p", count)
    H.delta(command)
end

return M
