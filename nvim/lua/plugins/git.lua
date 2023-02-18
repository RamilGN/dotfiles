local M = {}

function M.setup(use)
    -- Git decorations and buffer integration
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { hl = "GitSignsAdd", text = "│" },
                    untracked    = { hl = "GitSignsAdd", text = "┆" },
                    change       = { hl = "GitSignsChange", text = "│" },
                    changedelete = { hl = "GitSignsChange", text = "│" },
                    delete       = { hl = "GitSignsDelete", text = "│" },
                    topdelete    = { hl = "GitSignsDelete", text = "│" },
                }
            })
        end
    })

    -- Git links
    use({
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("gitlinker").setup({
                opts = {
                    print_url = false,
                },
                callbacks = {
                    ["gitlab.insales.ru"] = require("gitlinker.hosts").get_gitlab_type_url
                },
            })
        end
    })

    -- Useful commands
    use({ "tpope/vim-fugitive" })
end

return M
