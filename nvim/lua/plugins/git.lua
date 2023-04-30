return {

    -- Git decorations and buffer integration
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add          = { hl = "GitSignsAdd", text = "│" },
                untracked    = { hl = "GitSignsAdd", text = "┆" },
                change       = { hl = "GitSignsChange", text = "│" },
                changedelete = { hl = "GitSignsChange", text = "│" },
                delete       = { hl = "GitSignsDelete", text = "│" },
                topdelete    = { hl = "GitSignsDelete", text = "│" },
            },
            on_attach = function(buffer)
                -- Links
                require("gitlinker").setup({
                    opts = {
                        print_url = false,
                    },
                    callbacks = {
                        ["gitlab.insales.ru"] = require("gitlinker.hosts").get_gitlab_type_url
                    },
                })

                local k = require("config.keymaps_new")
                k.git.default(buffer)
                k.git.signs(buffer)
                k.git.fugitive(buffer)
                k.git.linker(buffer)
                k.git.telescope(buffer)
            end,
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
        end
    },

    -- Git aliases
    { "tpope/vim-fugitive",   cmd = "G" },

    -- Git links
    { "ruifm/gitlinker.nvim", lazy = true }
}
