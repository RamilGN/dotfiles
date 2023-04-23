return {
    -- Git aliases
    { "tpope/vim-fugitive", cmd = "G" },

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
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end
            end,
        },
        config = function()
            require("gitsigns").setup({
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
        end,
        keymaps = {
            { "<leader>gy", function() require("gitlinker").get_buf_range_url("n") end, desc = "Git copy link" },
            { "<leader>gy", function() require("gitlinker").get_buf_range_url("v") end, desc = "Git copy link", mode = "v" },

        }
    }

}
