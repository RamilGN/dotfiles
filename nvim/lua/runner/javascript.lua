local M = {}

local Util = require("util")

M.run = function(opts)
    Util.vterm("node " .. opts.current_buffer)
end

return M
