local Util = require("note.util")

local M = {}

M.setup = function(config)
    -- delete default key and get to var
    local exec = function()
        local default_workspace = config.workspaces.default
        if default_workspace == nil then
            vim.notify("Please, provide default workspace", vim.log.levels.ERROR)
            return
        end

        local current_buffer = vim.fn.expand("%:p")
        for path, value in pairs(config.workspaces) do
            if current_buffer:find(value.path) then
            end
        end
    end

    vim.api.nvim_create_user_command("NoteTodo", function(_)
        exec()
    end, { nargs = "*", range = true })
end

return M
