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

-- Trim trailing whitespaces
vim.api.nvim_create_user_command(
    "TrimWhitespaces", function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
    end,
    { nargs = 0 }
)

-- Set color bar
vim.api.nvim_create_user_command("SetColorColumn",
    function()
        vim.opt.colorcolumn = tostring(vim.v.count)
    end,
    { nargs = "?", count = true }
)

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

-- Run rspec for current file
vim.api.nvim_create_user_command( "InsalesRspec",
    function(opts)
        local line = opts.fargs[1]
        local path = vim.fn.expand("%:p:.")
        local command = nil

        if line then
            command = [[docker exec -it -w /home/app/code insales_insales_1]] .. [[ bundle exec rspec ]] .. path .. [[:]] .. line
        else
            command = [[docker exec -it -w /home/app/code insales_insales_1]] .. [[ bundle exec rspec ]] .. path
        end

        f.vim.vterm(command)
    end,
    { nargs = "?" }
)

-- Run rspec for current file
vim.api.nvim_create_user_command("SynchRspec",
    function(opts)
        local line = opts.fargs[1]
        local path = vim.fn.expand("%:p:.:h")

        if line then
            f.vim.vterm([[docker exec -it -w /home/app/code 1c_synch_1c_sync_1]] .. [[ bundle exec rspec ]] .. path .. [[:]] .. line)
        else
            f.vim.vterm([[docker exec -it -w /home/app/code 1c_synch_1c_sync_1]] .. [[ bundle exec rspec ]] .. path)
        end
    end,
    { nargs = "?" }
)

vim.api.nvim_create_user_command("RunCurrentFile",
    function()
        f.exec.cmd()
    end,
    { nargs = "*", range = true }
)
