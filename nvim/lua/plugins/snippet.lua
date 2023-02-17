local M = {}

function M.setup(use)
    use({ "rafamadriz/friendly-snippets" })

    use({
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    })
end

return M
