local f = require("functions")
local toggleterm = require("toggleterm")

-- Git log
vim.api.nvim_create_user_command("GitLog",
    function(opts)
        local range = (opts.range == 0 and opts.args) or (opts.line1 .. [[,]] .. opts.line2)
        if range == "" then
            f.git.delta([[log -p --stat --follow ]] .. [[%]])
        else
            f.git.delta([[log -p -L]] .. range .. [[:%]])
        end
    end,
    { nargs = "?", range = true }
)

-- Git log global
vim.api.nvim_create_user_command("GitLogG",
    function()
        f.git.delta([[log -p --stat]])
    end,
    { nargs = "?" }
)

-- Git show
vim.api.nvim_create_user_command("GitShow",
    function(opts)
        local commit_hash = opts.args
        if commit_hash == "" then
            local cword = vim.fn.expand("<cword>")
            f.vim.closewin()
            f.git.delta([[show -p --stat ]] .. cword)
        else
            f.git.delta([[show -p --stat ]] .. commit_hash)
        end
    end,
    { nargs = "?" }
)

-- Set color bar
vim.api.nvim_create_user_command("SetColorColumn",
    function()
        vim.opt.colorcolumn = tostring(vim.v.count)
    end,
    { nargs = "?", count = true }
)

-- TODO: move to functions
-- ToggleTerm commands
vim.api.nvim_create_user_command("ToggleTermSendCurrentLineNoTW",
    function(opts)
        toggleterm.send_lines_to_terminal("single_line", false, opts)
    end,
    { nargs = "?" }
)
vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionNoTW",
    function(opts)
        toggleterm.send_lines_to_terminal("visual_selection", false, opts)
    end,
    { range = true, nargs = "?" }
)

-- Run in vterm
vim.api.nvim_create_user_command("V",
    function(opts) f.vim.vterm(opts.fargs[1]) end,
    { nargs = 1 }
)

-- Run current file
vim.api.nvim_create_user_command("Run",
    function(opts) f.runner.cmd(opts) end,
    { nargs = "*", range = true }
)
