local Terminal = require("term.terminal")

local M = {}
local P = {}

M.setup = function()
    vim.api.nvim_create_user_command("TermDiag", function(_)
        vim.print({ terminal = Terminal, respawn = LastSpawnedTerm })
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
        local command = table.concat(opts.fargs, " ") .. " && sleep 0.1"
        local full_command = string.format("%s '%s'", "/bin/zsh -i -c", command)
        M.spawn({ cmd = full_command, bufname = command })
    end, {
        nargs = "?",
        range = true,
    })

    vim.api.nvim_create_user_command("TermRespawn", function(opts)
        M.respawn()
    end, { nargs = "?", range = true })

    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Normal mode" })
    vim.keymap.set("t", "<C-w>c", "<C-\\><C-n><C-w>c", { desc = "Close terminal" })
    vim.keymap.set("t", "<C-u>", "<C-\\><C-n><C-u>", { desc = "Scroll up" })
    vim.keymap.set({ "n", "t" }, [[<C-\>]], "<Cmd>TermToggleFloat<CR>")
    vim.keymap.set("n", "<leader>ot", "<Cmd>TermToggleVsplit<CR>")
    vim.keymap.set({ "n", "v" }, "<C-2>", ":TermSend<CR>")
    vim.keymap.set("n", "<C-3>", "<Cmd>TermSend q<CR>")
    vim.keymap.set("n", "<C-->", "<Cmd>TermSend <Up><CR>")
    vim.keymap.set("n", "<C-=>", "<Cmd>TermSend <Down><CR>")
    vim.keymap.set("n", "<C-0>", "<Cmd>TermSend <CR>")
    vim.keymap.set("n", "<leader>re", ":TermRespawn<CR>", { desc = "Respawn last term" })
    vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
    -- vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
    -- vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
    -- vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
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
