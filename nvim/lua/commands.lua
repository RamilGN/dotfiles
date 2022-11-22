local utils = require("utils")
local api = vim.api
local cmd = vim.cmd
local command = vim.api.nvim_create_user_command
local fn = vim.fn
local opt = vim.opt

-- Git log
command(
    "GitLog",
    function(opts)
        local range = (opts.range == 0 and opts.args) or (opts.line1 .. [[,]] .. opts.line2)
        if range == "" then
            utils.gitdelta([[log -p --stat --follow ]] .. [[%]])
        else
            utils.gitdelta([[log -p -L]] .. range .. [[:%]])
        end
    end,
    { nargs = "?", range = true }
)

-- Git show
command(
    "GitShow",
    function(opts)
        local commit_hash = opts.args
        if commit_hash == "" then
            local cword = fn.expand("<cword>")
            utils.closewin()
            utils.gitdelta([[show -p --stat ]] .. cword)
        else
            utils.gitdelta([[show -p --stat ]] .. commit_hash)
        end
    end,
    { nargs = "?" }
)

-- Trim trailing whitespaces
command(
    "TrimWhitespaces", function()
        local curpos = api.nvim_win_get_cursor(0)
        cmd([[keeppatterns %s/\s\+$//e]])
        api.nvim_win_set_cursor(0, curpos)
    end,
    { nargs = 0 }
)

-- Set color bar
command(
    "SetColorColumn",
    function()
        local current = api.nvim_win_get_option(0, "colorcolumn")
        local filetype = api.nvim_buf_get_option(0, "filetype")
        local value = "100"
        if filetype == "markdown" then
            value = "80"
        elseif filetype == "ruby" then
            value = "120"
        end
        local cval = current == "" and value or ""
        opt.colorcolumn = cval
    end,
    { nargs = "?", range = true }
)
