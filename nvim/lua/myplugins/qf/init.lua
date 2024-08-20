local M = { group = nil }
local P = {}

M.setup = function()
    P.set_global_keymaps()
    P.create_group()
    P.create_init_autocmd()
end

P.create_group = function()
    M.group = vim.api.nvim_create_augroup("QFedit", { clear = true })
end

P.create_init_autocmd = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = M.qf_group,
        nested = true,
        pattern = "quickfix",
        callback = function(initopts)
            P.set_buf_keymaps(initopts)
            -- P.create_write_autocmd(initopts)
            -- P.trigger_write_for_autocmd(initopts)
            -- P.prepare_buffer(initopts)
        end,
    })
end

P.set_global_keymaps = function(initopts)
    vim.keymap.set("n", "<leader>q", "<Cmd>copen<CR>", { desc = "Open quick fix list" })
end

P.set_buf_keymaps = function(initopts)
    -- Quickifx list.
    local tsrm = require("nvim-treesitter.textobjects.repeatable_move")
    local next_qf_repeat, prev_qf_repeat = tsrm.make_repeatable_move_pair(function()
        local ok, _, _ = pcall(vim.cmd.cnext)

        if ok then
            return
        else
            pcall(vim.cmd.cfirst)
        end
    end, function()
        local ok, _, _ = pcall(vim.cmd.cprevious)
        if ok then
            return
        else
            pcall(vim.cmd.clast)
        end
    end)
    vim.keymap.set("n", "]q", next_qf_repeat, { desc = "Next qf" })
    vim.keymap.set("n", "[q", prev_qf_repeat, { desc = "Prev qf" })
    vim.keymap.set("n", "<CR>", "<CR><C-W>p", { buffer = initopts.buf })
end

P.create_write_autocmd = function(initopts)
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        group = vim.api.nvim_create_augroup("QFedit_" .. initopts.buf, { clear = true }),
        pattern = "quickfix-" .. initopts.buf,
        callback = function(writeopts)
            P.save_qf(writeopts)
        end,
    })
end

P.trigger_write_for_autocmd = function(initopts)
    vim.cmd("write! quickfix-" .. initopts.buf)
end

P.prepare_buffer = function(initopts)
    vim.bo[initopts.buf].modifiable = true
end

P.save_qf = function(writeopts)
    local buf = writeopts.buf
    if not vim.bo[buf].modified then
        vim.print("not writing...")
        return
    end

    vim.print("writing...")
    vim.bo[buf].modified = false
end

return M
