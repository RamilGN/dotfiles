return {
    -- Git decorations and buffer integration
    {
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
    },

    -- Git links
    {
        "ruifm/gitlinker.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
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
    },

    -- Git aliases
    { "tpope/vim-fugitive" }
}
