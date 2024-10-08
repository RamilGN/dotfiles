local Term = require("myplugins.term.init")

local M = {}

M.run = function(opts)
    local bin = opts.current_buffer:gsub(".rkt$", "")
    Term.spawn({ cmd = "raco exe " .. opts.current_buffer .. " && " .. bin })
end

return M
