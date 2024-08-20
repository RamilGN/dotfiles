local Term = require("myplugins.term.init")

local M = {}

M.run = function(opts)
    Term.spawn({ cmd = "lua " .. opts.current_buffer })
end

return M
