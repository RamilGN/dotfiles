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
        end,
    })
end

-- stylua: ignore
P.set_global_keymaps = function()
    vim.keymap.set("n", "<leader>qq", function() require("quicker").toggle() end, { desc = "Toggle quickfix" })
    vim.keymap.set("n", "<leader>qs", P.grep_on_quickfix, { desc = "Grep qf" })
    vim.keymap.set("n", "<leader>qf", P.find_files_on_quickfix, { desc = "Find files qf" })
    vim.keymap.set("n", "<leader>qh", "<Cmd>Telescope quickfixhistory<CR>", { desc = "History qf" })
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

P.grep_on_quickfix = function()
    require("telescope.builtin").live_grep({ search_dirs = require("myplugins.util.init").quickfix_files() })
end

P.find_files_on_quickfix = function()
    require("telescope.builtin").find_files({ search_dirs = require("myplugins.util.init").quickfix_files() })
end

return M
