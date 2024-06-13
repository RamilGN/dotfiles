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
        Terminal.toggle(vim.v.count, Terminal.types.FLOAT)
    end, {})

    vim.api.nvim_create_user_command("TermToggleVsplit", function(_)
        Terminal.toggle(vim.v.count, Terminal.types.VSPLIT)
    end, {})

    vim.api.nvim_create_user_command("TermSend", function(opts)
        local mode = Terminal.line_modes.LINE

        if opts.range > 0 then
            mode = Terminal.line_modes.LINES
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

    vim.api.nvim_create_user_command("T", function(opts)
        local command = table.concat(opts.fargs, " ")
        local full_command = string.format("%s '%s'", "/bin/zsh -i -c", command)
        M.spawn({ cmd = full_command })
    end, {
        nargs = "?",
        range = true,
    })

    vim.api.nvim_create_user_command("TermRespawn", function(opts)
        M.respawn()
    end, { nargs = "?", range = true })
end

LastSpawnedTerm = nil

---@param opts TermNew
M.spawn = function(opts)
    local term = Terminal.term:new(opts)
    P.save_last_spawned_term(term)
    Terminal.create(term)
end

M.respawn = function()
    if LastSpawnedTerm == nil then
        Terminal.error("no term to respawn")
        return
    end

    M.spawn(LastSpawnedTerm)
end

---@param term Term
P.save_last_spawned_term = function(term)
    LastSpawnedTerm = term
end

return M
