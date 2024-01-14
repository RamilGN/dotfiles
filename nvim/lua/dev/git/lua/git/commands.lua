local Util = require("git.util")

local M = {}

M.commands = {}

function M.execute_cmd(command, opts)
    local args = {}
    for arg in command:gmatch("%w+") do
        table.insert(args, arg)
    end

    local cmd = M.commands[args[1]]
    if cmd then
        cmd(opts, args)
    else
        vim.notify("[gitx]: unknown command " .. "`" .. command .. "`", vim.log.levels.ERROR)
    end
end

M.setup = function(config)
    local delta = function(command)
        Util.delta(command, config)
    end

    M.commands = {
        log = function(opts, _)
            if opts.range > 0 then
                local range = opts.line1 .. [[,]] .. opts.line2
                delta("log -p -L" .. range .. ":%")
            else
                delta("log -p --stat --follow " .. "%")
            end
        end,
        logglobal = function(opts, args)
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
    }

    vim.api.nvim_create_user_command("Gitx", function(opts)
        local cmd = vim.trim(opts.args or "")
        M.execute_cmd(cmd, opts)
    end, {
        nargs = "?",
        range = true,
        desc = "Gitx",
        complete = function(_, line)
            if line:match("^%s*Gitx %w+ ") then
                return {}
            end

            local prefix = line:match("^%s*Gitx (%w*)") or ""
            vim.notify(prefix)
            return vim.tbl_filter(function(key)
                local start_idx, _ = key:find(prefix)
                return start_idx == 1
            end, vim.tbl_keys(M.commands))
        end,
    })
end

return M
