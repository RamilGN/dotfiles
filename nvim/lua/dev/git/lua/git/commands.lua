local M = {}

M.setup = function(_)
    -- Git log
    vim.api.nvim_create_user_command("GitLog",
        function(opts)
            local f = require("functions")

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
            local f = require("functions")
            f.git.delta([[log -n 300 -p --stat]])
        end,
        { nargs = "?" }
    )
    -- Git show
    vim.api.nvim_create_user_command("GitShow",
        function(opts)
            local f = require("functions")

            local commit_hash = opts.args
            if commit_hash == "" then
                local cword = vim.fn.expand("<cword>")
                f.git.delta([[show -p --stat ]] .. cword, { split = true })
            else
                f.git.delta([[show -p --stat ]] .. commit_hash, { split = true })
            end
        end,
        { nargs = "?" }
    )
    -- Git show previous
    vim.api.nvim_create_user_command("GitShowPrev",
        function()
            local f = require("functions")

            f.git.delta([[show -p --stat HEAD~1]])
        end,
        { nargs = "?" }
    )
end

return M
