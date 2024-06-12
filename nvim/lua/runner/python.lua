local Term = require("term")

local M = {}

M.run = function(opts)
    Term.spawn({ cmd = "python3 " .. opts.current_buffer })
end

return M
