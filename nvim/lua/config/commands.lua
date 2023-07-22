return {
    setup = function()
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

        vim.api.nvim_create_user_command("GitShowPrev",
            function()
                local f = require("functions")

                f.git.delta([[show -p --stat HEAD~1]])
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

        -- Run in terminal
        vim.api.nvim_create_user_command("V",
            function(opts)
                local f = require("functions")

                f.vim.vterm("/bin/zsh -i -c '" .. opts.fargs[1] .. "'")
            end,
            { nargs = 1 }
        )

        -- Run current file
        vim.api.nvim_create_user_command("Run",
            function(opts)
                local f = require("functions")

                f.runner.run(opts)
            end,
            { nargs = "*", range = true }
        )

        -- GPT
        vim.api.nvim_create_user_command("Gpt",
            function(opts)
                local f = require("functions")

                local gpt = function(text)
                    f.vim.vterm("zsh ~/dotfiles/zshrc/scripts/gpt.zsh " .. text)
                end

                if opts.range > 0 then
                    local tmpn = os.tmpname() .. "." .. vim.fn.expand("%:e")
                    vim.defer_fn(function() os.remove(tmpn) end, 3000)
                    pcall(function()
                        local answer = table.concat(opts.fargs, " ")
                        local text = f.vim.get_visual_selection_v2()
                        text = answer .. ":\n\n" .. text
                        local tmp = io.open(tmpn, "w+b")
                        if tmp ~= nil then
                            tmp:write(text)
                            tmp:close()
                        end

                        gpt("-f " .. tmpn)
                    end)
                elseif #opts.fargs > 0 then
                    local text = table.concat(opts.fargs, " ")
                    gpt("'" .. text .. "'")
                else
                    vim.api.nvim_echo({ { "Please, provide args", "WarningMsg" } }, false, {})
                end
            end,
            { nargs = "*", range = true }
        )
    end
}
