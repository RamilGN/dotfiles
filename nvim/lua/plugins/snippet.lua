local M = {}

function M.setup(use)
    use({
        "L3MON4D3/LuaSnip",
        config = function()
            local ls = require("luasnip")

            ls.config.set_config {
                history = false,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true
            }
        end
    })
end

return M
