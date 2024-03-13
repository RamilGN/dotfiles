local Term = require("term")

local M = {}

M.run = function(opts)
    Term.exec("node " .. opts.current_buffer)
end

return M
