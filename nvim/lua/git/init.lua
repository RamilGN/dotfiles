local T = require("term.terminal")

---@class Gitx
local M = {}

--- @class ExecOpts
--- @field delta? boolean
--- @field cmd string

---@param opts ExecOpts
local function exec(opts)
    local cmd = "git --no-pager " .. opts.cmd
    if opts.delta then
        cmd = cmd .. " | delta --paging=never"
    end
    cmd = cmd .. " && sleep 0.1"

    local term = T.term:new({
        id = 0,
        type = T.types.ENEW,
        close_on_exit = false,
        cmd = cmd,
        startinsert = false,
        scroll_to_bottom = false,
        hidden = false,
        bufname = string.format("git %s", opts.cmd),
    })

    T.create(term)
end

M.log = function(filename)
    local cmd = string.format("log -p --stat %s", filename)
    exec({ cmd = cmd, delta = true })
end

M.log_range = function(filename, line1, line2)
    local cmd = string.format("log -p -L%s,%s:%s", line1, line2, filename)
    exec({ cmd = cmd, delta = true })
end

M.log_global = function(count)
    local cmd = string.format("log -n %s", count)
    exec({ cmd = cmd })
end

M.log_global_p = function(count)
    local cmd = string.format("log -n %s --stat -p", count)
    exec({ cmd = cmd, delta = true })
end

M.show = function(object)
    exec({ cmd = "show -p --stat " .. object, delta = true })
end

M.show_cur_commit = function()
    exec({ cmd = "show -p --stat HEAD", delta = true })
end

M.setup = function()
    vim.api.nvim_create_user_command("GitLogGlobal", function(opts)
        M.log_global(opts.fargs[1] or 500)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("GitLogGlobalP", function(opts)
        M.log_global_p(opts.fargs[1] or 500)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("GitLogCurrentFile", function(opts)
        local filename = vim.api.nvim_buf_get_name(0)

        if opts.range > 0 then
            M.log_range(filename, opts.line1, opts.line2)
        else
            M.log(filename)
        end
    end, { range = true })

    vim.api.nvim_create_user_command("GitShow", function(opts)
        if opts.args ~= "" then
            return M.show(opts.args)
        end

        local curword = vim.fn.expand("<cWORD>")
        if curword == "commit" then
            local line = vim.api.nvim_get_current_line()
            local commit = vim.split(line, " ")[2]
            M.show(commit)
        else
            M.show(curword)
        end
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("GitShowCurCommit", function()
        M.show_cur_commit()
    end, { nargs = 0 })
end

return M
