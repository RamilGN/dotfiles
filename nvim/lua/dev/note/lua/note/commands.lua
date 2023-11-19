local Util = require("note.util")

local M = {}

M.setup = function(config)
    vim.api.nvim_create_user_command("NoteCreate", function(_)
        Util.create_today_journal(config.journal_dir)
    end, { nargs = "*", range = true })

    vim.api.nvim_create_user_command("NoteSearch", function(_)
        require("telescope.builtin").live_grep({ cwd = config.journal_dir })
    end, { nargs = "*", range = true })

    vim.api.nvim_create_user_command("NoteOpen", function(_)
        require("telescope.builtin").find_files({ cwd = config.journal_dir })
    end, { nargs = "*", range = true })
end

return M
