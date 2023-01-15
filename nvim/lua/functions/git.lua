local v = require("functions.vim")

local M = {}

M.delta = function(command)
    local delta = [[git --no-pager ]] .. command .. [[ \| delta --paging=never]]
    v.vterm(delta)
end

M.check = function()
    vim.cmd([[silent! !git rev-parse]])
    if vim.v.shell_error == 0 then
        return true
    else
        return false
    end
end

return M
