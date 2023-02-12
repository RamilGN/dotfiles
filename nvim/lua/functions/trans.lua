local v = require("functions.vim")

local M = {}

M.translate = function()
    vim.ui.input(
        "Translate",
        function(input)
            if not input then
                return
            end
            v.vterm("trans " .. input)
        end)
end

return M
