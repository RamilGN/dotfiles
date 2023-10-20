local M = {}

M.setup = function(opts)
    require("git.commands").setup(opts)
end

return M
