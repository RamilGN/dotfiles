require("term.constants")
local Terminal = require("term.terminal")

local Util = require("util")

local M = {}

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

        Terminal.send(mode)
    end, { range = true })

    vim.api.nvim_create_user_command("TermExec", function(opts)
        local command = table.concat(opts.fargs, " ")
        Terminal.exec(command)
    end, {
        nargs = "?",
        range = true,
    })

    vim.api.nvim_create_user_command("T", function(opts)
        local command = table.concat(opts.fargs, " ")
        M.exec(string.format("%s '%s'", "/bin/zsh -i -c", command))
    end, {
        nargs = "?",
        range = true,
    })
end

-- TODO: naming
M.exec = function(command)
    local curfile = vim.fn.expand("%")
    local full_command = ("TermExec " .. command)
    local expanded_command = full_command.gsub(full_command, "%%", curfile)
    Util.save_last_command(expanded_command, command)
    vim.cmd(expanded_command)
end

return M
