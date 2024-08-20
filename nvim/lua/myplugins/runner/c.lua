local Term = require("myplugins.term.init")

local M = {}

M.run = function(opts)
    local curb = opts.current_buffer
    local cmpf = curb .. ".out"
    Term.spawn({ cmd = [[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf })
end

return M
