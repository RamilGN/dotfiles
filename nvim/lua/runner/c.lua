local Term = require("term")

local M = {}


M.run = function(opts)
    local curb = opts.current_buffer
    local cmpf = curb .. ".out"
    Term.exec([[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf)
end

return M
