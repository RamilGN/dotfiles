local M = {}

-- local Terminal = require("term.terminal")

M.delta = function(command)
    local cmd = "git --no-pager " .. command .. " | delta --paging=never"

    Terminal.create(Term:new({
        id = 0,
        type = TERM_TYPE_ENEW,
        close_on_exit = false,
        cmd = cmd,
        startinsert = false,
        scroll_to_bottom = false,
        hidden = true,
    }))
end

M.error = function(msg)
    vim.notify(string.format("[gitx]: %s", msg, vim.log.levels.ERROR))
end

return M
