local Term = require("myplugins.term.init")

local M = {}

M.run = function(opts)
    Term.spawn({ cmd = "python3 " .. opts.current_buffer })
end

return M
