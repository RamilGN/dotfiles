local M = {}

local Util = require("util.init")

M.run = function(opts)
    local bin = opts.current_buffer:gsub(".rkt$", "")
    Util.vterm("raco exe " .. opts.current_buffer .. " && " .. bin)
end

return M
