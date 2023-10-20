local M = {}

M.setup = function(_)
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

return M
