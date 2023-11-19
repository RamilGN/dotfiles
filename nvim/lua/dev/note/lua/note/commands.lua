local Util = require("note.util")

local M = {}

M.setup = function(config)
    vim.api.nvim_create_user_command("Note", function(opts)
        Util.create_today_journal(config.journal_dir)
    end, { nargs = "*", range = true })
end

return M
