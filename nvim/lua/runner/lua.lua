local Term = require("term")

local M = {}

M.run = function(opts)
    Term.exec("lua " .. opts.current_buffer)
end

return M
