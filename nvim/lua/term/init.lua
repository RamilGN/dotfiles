require("term.constants")
local Terminal = require("term.terminal")

local M = {}
local P = {}

M.setup = function()
    vim.api.nvim_create_user_command("TermDiag", function(_)
        vim.print(Terminal)
    end, {})

    vim.api.nvim_create_user_command("Term", function(_)
        Terminal.exec(vim.o.shell)
    end, {})

    vim.api.nvim_create_user_command("TermToggleFloat", function(_)
        Terminal.toggle(vim.v.count, TERM_TYPE_FLOAT)
    end, {})

    vim.api.nvim_create_user_command("TermToggleVsplit", function(_)
        Terminal.toggle(vim.v.count, TERM_TYPE_VSPLIT)
    end, {})

    vim.api.nvim_create_user_command("TermSend", function(opts)
        local mode = TERM_SEND_MODE_LINE

        if opts.range > 0 then
            mode = TERM_SEND_MODE_LINES
        end

        local cmd = nil
        if #opts.fargs > 0 then
            cmd = table.concat(opts.fargs, " ")
        end

        Terminal.send(mode, cmd)
    end, {
        nargs = "?",
        range = true,
    })

    vim.api.nvim_create_user_command("TermExec", function(opts)
        if #opts.fargs == 0 then
            Terminal.error("pass the command ex. `TermExec git log`")
            return
        end

        local command = table.concat(opts.fargs, " ")
        local full_command = string.format("%s && sleep 0.1", command)
        Terminal.exec(full_command)
    end, {
        nargs = "?",
        range = true,
    })

    vim.api.nvim_create_user_command("T", function(opts)
        local command = table.concat(opts.fargs, " ")
        local full_command = string.format("%s '%s'", "/bin/zsh -i -c", command)
        M.exec(full_command)
    end, {
        nargs = "?",
        range = true,
    })
end

M.exec = function(command)
    local curfile = vim.fn.expand("%")
    local full_command = ("TermExec " .. command)
    local expanded_command = full_command.gsub(full_command, "%%", curfile)

    P.save_last_command(expanded_command, command)

    vim.cmd(expanded_command)
end

P.save_last_command = function(command, cmd)
    vim.g.last_command = command
    vim.g.last_cmd = cmd
end

return M
