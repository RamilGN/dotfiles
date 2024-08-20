local U = require("myplugins.util")
local UB = require("myplugins.util.buf")
local T = require("myplugins.term.init")

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

    T.spawn({ cmd = cmd, bufname = string.format("git %s", opts.cmd) })
end

local function get_url(opts)
    local url = ""

    if opts.range > 0 then
        url = M.url(opts.line1, opts.line2)
    else
        url = M.url()
    end

    vim.print(url)

    return url
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

M.url = function(line1, line2)
    local remote_and_branch = vim.split(vim.fn.system("git rev-parse --abbrev-ref HEAD@{push}"), "/")
    local remote, branch = vim.trim(remote_and_branch[1]), vim.trim(remote_and_branch[2])

    local remote_url = vim.fn.system(string.format("git remote get-url %s", remote))
    remote_url = string.gsub(remote_url, "%.git\n$", "")

    local host = vim.trim(vim.split(remote_url, "@", { trimempty = true })[2])
    local repo_filepath = vim.trim(vim.fn.system(string.format("git ls-files --full-name %s", UB.cur_buf_abs_path())))

    local url = ""
    if string.match(host, "github") then
        url = string.format("https://%s/blob/%s/%s", host, branch, repo_filepath)
    elseif string.match(host, "gitlab") then
        host = string.gsub(host, ":", "/")
        url = string.format("https://%s/-/blob/%s/%s", host, branch, repo_filepath)
    end

    if line1 then
        url = string.format("%s#L%s", url, line1)
    end

    if line2 then
        url = string.format("%s-L%s", url, line2)
    end

    return url
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

    vim.api.nvim_create_user_command("GitUrlCopy", function(opts)
        U.copy_to_clipboard(get_url(opts))
    end, { range = true })

    vim.api.nvim_create_user_command("GitUrlOpen", function(opts)
        U.sysopen(get_url(opts))
    end, { range = true })

    vim.keymap.set({ "n", "v" }, "<leader>gll", ":GitLogCurrentFile<CR>", { desc = "Git log currrent file" })
    vim.keymap.set("n", "<leader>glg", "<Cmd>GitLogGlobalP<CR>", { desc = "Git log global" })
    vim.keymap.set("n", "<leader>gii", "<Cmd>GitShow<CR>", { desc = "Git show" })
end

return M
