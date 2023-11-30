local Util = require("git.util")

local M = {}

M.commands = {}

M.setup = function(config)
    local delta = function(command)
        Util.delta(command, config)
    end

    M.commands = {
        GitLog = {
            cmd = function(opts)
                local range = (opts.range == 0 and opts.args) or (opts.line1 .. [[,]] .. opts.line2)
                if range == "" then
                    delta("log -p --stat --follow " .. "%")
                else
                    delta("log -p -L" .. range .. ":%")
                end
            end,
            opts = { nargs = "?", range = true },
        },
        GitLogG = {
            cmd = function(_)
                delta("log -n 300 -p --stat")
            end,
            opts = { nargs = "?" },
        },
        GitShow = {
            cmd = function(opts)
                local commit_hash = opts.args
                if commit_hash == "" then
                    local cword = vim.fn.expand("<cword>")
                    delta("show -p --stat " .. cword)
                else
                    delta("show -p --stat " .. commit_hash)
                end
            end,
            opts = { nargs = "?" },
        },
        GitShowPrev = {
            cmd = function(_)
                delta("show -p --stat")
            end,
            opts = { nargs = "?" },
        },
    }

    for name, command in pairs(M.commands) do
        vim.api.nvim_create_user_command(name, command.cmd, command.opts)
    end
end

return M
