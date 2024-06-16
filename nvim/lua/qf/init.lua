local M = { group = nil }
local P = {}

M.setup = function()
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
            P.set_keymaps(initopts)
            -- P.create_write_autocmd(initopts)
            -- P.trigger_write_for_autocmd(initopts)
            -- P.prepare_buffer(initopts)
        end,
    })
end

P.set_keymaps = function(initopts)
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = initopts.buf })
    vim.keymap.set("n", "j", "j<CR><C-W>p", { desc = "Move cursor down and preview entry", buffer = initopts.buf })
    vim.keymap.set("n", "k", "k<CR><C-W>p", { desc = "Move cursor up and preview entry", buffer = initopts.buf })
    vim.keymap.set("n", "<C-u>", "<C-u><CR><C-W>p", { desc = "Move cursor up and preview entry", buffer = initopts.buf })
    vim.keymap.set("n", "<C-d>", "<C-d><CR><C-W>p", { desc = "Move cursor down and preview entry", buffer = initopts.buf })
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
