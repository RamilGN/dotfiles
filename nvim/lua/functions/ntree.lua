local view = require("nvim-tree.view")
local api = require("nvim-tree.api")
local core = require("nvim-tree.core")

local M = {}

M.toggle = function()
    if view.is_visible() then
        api.tree.close()
    else
        local buf = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(buf)
        local cwd = vim.fn.getcwd()

        core.init(cwd)
        view.open_in_current_win({ hijack_current_buf = false, resize = false })
        require("nvim-tree.renderer").draw()

        if bufname == "" or vim.loop.fs_stat(bufname) == nil then
            return
        end
        require("nvim-tree.actions.finders.find-file").fn(bufname)
    end
end

return M
