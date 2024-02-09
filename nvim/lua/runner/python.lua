local M = {}

local Util = require("util")

M.run = function(opts)
    Util.vterm("python3 " .. opts.current_buffer)
end

return M
