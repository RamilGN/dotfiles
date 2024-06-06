local Gitlog = require("gitx.log")
local GitShow = require("gitx.show")

---@class Gitx
local M = {}

M.setup = function()
    vim.api.nvim_create_user_command("GitLogGlobal", function(opts)
        Gitlog.log_global(opts.fargs[1] or 500)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("GitLogGlobalP", function(opts)
        Gitlog.log_global_p(opts.fargs[1] or 500)
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("GitLogCurrentFile", function(opts)
        local filename = vim.api.nvim_buf_get_name(0)

        if opts.range > 0 then
            Gitlog.log_range(filename, opts.line1, opts.line2)
        else
            Gitlog.log(filename)
        end
    end, { range = true })

    vim.api.nvim_create_user_command("GitShow", function(opts)
        if opts.args ~= "" then
            return GitShow.show(opts.args)
        end

        local curword = vim.fn.expand("<cword>")
        if curword == "commit" then
            local line = vim.api.nvim_get_current_line()
            local commit = vim.split(line, " ")[2]
            GitShow.show(commit)
        else
            GitShow.show(curword)
        end
    end, { nargs = "?" })

    vim.api.nvim_create_user_command("GitShowCurCommit", function()
        GitShow.show_cur_commit()
    end, { nargs = 0 })
end

return M
