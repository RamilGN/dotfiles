local gomodifytags = require("myplugins.go.gomodifytags")
local gotests = require("myplugins.go.gotests")
local gosrc = require("myplugins.go.gosrc")
-- gofumpt
-- goimports
-- golines
-- gomodifytags
-- gopls
-- gotests

local M = { group = nil }
local P = {}

M.setup = function()
    P.create_group()
    P.create_init_autocmd()
    P.set_commands()
end

P.create_group = function()
    M.group = vim.api.nvim_create_augroup("GoInit", { clear = true })
end

P.create_init_autocmd = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = M.group,
        pattern = "*.go",
        callback = function(initopts)
            P.set_buf_autocommands(initopts)
            P.set_buf_commands(initopts)
            P.set_buf_keymaps(initopts)
        end,
    })
end

P.set_commands = function(_)
    gosrc.set_commands()
end

P.set_buf_autocommands = function(initopts)
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = vim.api.nvim_create_augroup("GoFormatOnSave_" .. initopts.buf, { clear = true }),
    --     buffer = initopts.buf,
    --     callback = function(_)
    --         require("conform").format({ lsp_fallback = true })
    --     end,
    -- })
end

P.set_buf_commands = function(initopts)
    gomodifytags.set_buf_commands(initopts.buf)
    gotests.set_buf_commands(initopts.buf)
end

P.set_buf_keymaps = function(initopts)
    vim.keymap.set("n", "<leader>ng", function()
        vim.cmd("e ~/workspace/scratch/main.go")
    end, { buffer = initopts.buf, desc = "Scratch" })
end

return M
