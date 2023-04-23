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
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                local gs = package.loaded.gitsigns
                local tsrm = require "nvim-treesitter.textobjects.repeatable_move"
                local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
                local gitlinker = require("gitlinker")

                -- Links
                gitlinker.setup({
                    opts = {
                        print_url = false,
                    },
                    callbacks = {
                        ["gitlab.insales.ru"] = require("gitlinker.hosts").get_gitlab_type_url
                    },
                })

                map("n", "]g", next_hunk_repeat, "Next Hunk")
                map("n", "[g", prev_hunk_repeat, "Prev Hunk")
                map("n", "<leader>gy", function() require("gitlinker").get_buf_range_url("n") end, "Git copy link")
                map("v", "<leader>gy", function() require("gitlinker").get_buf_range_url("v") end, "Git copy link")
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
