local v = require("functions.vim")

local M = {}

M.translate = function(text, locale)
    v.vterm([[trans ]] .. [[']] .. text .. [[' ]] .. locale)
end

M.input = function()
    vim.ui.input(
        "Translate",
        function(input)
            if not input then
                return
            end
            M.translate(input, ":en")
        end)
end

return M
