local Term = require("term")

local M = {}

M.run = function(opts)
    Term.spawn({ cmd = "node " .. opts.current_buffer })
end

return M
