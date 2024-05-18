local Term = require("term")
local UtilJob = require("util.job")

---@class Gitx
local M = {}

local function delta(command)
    Term.exec("git --no-pager " .. command .. " | delta --paging=never")
end

local function error(msg)
    vim.notify(string.format("[gitx]: %s", msg, vim.log.levels.ERROR))
end

---@param gitx Gitx
---@param command string
---@param opts table
local function execute_cmd(gitx, command, opts)
    local args = {}
    for arg in command:gmatch("[%w_]+") do
        table.insert(args, arg)
    end

    local cmd = gitx.cmds[args[1]]
    if cmd then
        cmd(opts, args)
    else
        error(vim.notify("unknown command " .. "`" .. command .. "`"))
    end
end

M.cmds = {
    log = function(opts, _)
        if opts.range > 0 then
            local range = opts.line1 .. [[,]] .. opts.line2
            delta("log -p -L" .. range .. ":%")
        else
            delta("log -p --stat " .. "%")
        end
    end,
    log_global = function(_, args)
        local number_of_lines = args[2] or "500"
        delta("log -n " .. number_of_lines .. " -p --stat")
    end,
    show = function(_, args)
        local commit_hash = args[2]
        if commit_hash == nil then
            local cword = vim.fn.expand("<cword>")
            delta("show -p --stat " .. cword)
        else
            delta("show -p --stat " .. commit_hash)
        end
    end,
    showprev = function(_, _)
        delta("show -p --stat")
    end,
    url = function()
        UtilJob.system("git -v", { on_stdout = vim.print, on_stderr = error })

        -- local remote_and_branch = vim.split(vim.fn.system("git rev-parse --abbrev-ref HEAD@{push}"), "/")
        -- local remote, branch = vim.trim(remote_and_branch[1]), vim.trim(remote_and_branch[2])
        -- local remote_url = vim.fn.system(string.format("git remote get-url %s", remote))
        -- remote_url = string.gsub(remote_url, "%.git\n$", "")
        -- local remote_url = vim.split(remote_url, "git@", { trimempty = true })[1]

        -- https://github.com/RamilGN/dotfiles/blob/main/nvim/lua/gitx/init.lua
        -- local relative_file_path = vim.fn.system(string.format("git ls-files --full-name %s", UtilBuf.cur_buf_dir_abs_path()))
        -- vim.print(relative_file_path)
    end,
}

M.setup = function()
    vim.api.nvim_create_user_command("Gitx", function(opts)
        local cmd = vim.trim(opts.args or "")
        execute_cmd(M, cmd, opts)
    end, {
        nargs = "?",
        range = true,
        desc = "Gitx",
        complete = function(_, line)
            --- TODO: args[2] complete.
            local prefix = line:match("^%s*Gitx (%w*[_]?%w*)") or ""
            if M.cmds[prefix] ~= nil then
                return
            end

            return vim.tbl_filter(function(key)
                local start_idx, _ = key:find(prefix)
                return start_idx == 1
            end, vim.tbl_keys(M.cmds))
        end,
    })
end

return M
