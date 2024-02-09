local M = {}

local Util = require("util")

M.run = function(opts)
    local curb = opts.current_buffer
    local cmpf = curb .. ".out"
    Util.vterm([[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf)
end

return M
