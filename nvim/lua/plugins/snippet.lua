local M = {}

function M.setup(use)
    use({
        "L3MON4D3/LuaSnip",
        config = function()
            local ls = require("luasnip")
            local types = require "luasnip.util.types"

            ls.config.set_config {
                history = false,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true
                -- ext_opts = {
                --     [types.choiceNode] = {
                --         active = {
                --             virt_text = { { " « ", "NonTest" } },
                --         },
                --     },
                -- },
            }
        end
    })
end

return M
