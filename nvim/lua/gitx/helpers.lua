local M = {}

local T = require("term.terminal")

M.curbranch = function()
    return vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
end

M.delta = function(command)
    local cmd = "git --no-pager " .. command .. " | delta --paging=never && sleep 0.1"

    local term = T.term:new({
        id = 0,
        type = T.types.ENEW,
        close_on_exit = false,
        cmd = cmd,
        startinsert = false,
        scroll_to_bottom = false,
        hidden = true,
        bufname = string.format("git %s", command),
    })

    T.create(term)
end

M.exec = function(command)
    local cmd = "git --no-pager " .. command .. " && sleep 0.1"

    local term = T.term:new({
        id = 0,
        type = T.types.ENEW,
        close_on_exit = false,
        cmd = cmd,
        startinsert = false,
        scroll_to_bottom = false,
        hidden = true,
        bufname = string.format("git %s", command),
    })

    T.create(term)
end

M.error = function(msg)
    vim.notify(string.format("[gitx]: %s", msg, vim.log.levels.ERROR))
end

return M
