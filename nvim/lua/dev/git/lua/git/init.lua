local M = {}

M.setup = function(config)
    require("git.commands").setup(config)
end

return M
