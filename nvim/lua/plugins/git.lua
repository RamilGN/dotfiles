return {
    -- Git decorations and buffer integration.
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            max_file_length = 50000,
            signs = {
                add = { hl = "GitSignsAdd", text = "│" },
                untracked = { hl = "GitSignsAdd", text = "┆" },
                change = { hl = "GitSignsChange", text = "│" },
                changedelete = { hl = "GitSignsChange", text = "│" },
                delete = { hl = "GitSignsDelete", text = "│" },
                topdelete = { hl = "GitSignsDelete", text = "│" },
            },
            on_attach = function(buffer)
                local k = require("config.keymaps")
                k.git.signs(buffer)
            end,
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
        end,
    },
    -- Git aliases.
    {
        "tpope/vim-fugitive",
        dependencies = {
            -- Github.
            { "tpope/vim-rhubarb" },
            -- Gitlab.
            {
                "shumphrey/fugitive-gitlab.vim",
                config = function()
                    vim.g.fugitive_gitlab_domains = { "https://gitlab.insalesteam.ru" }
                end,
            },
        },
        keys = require("config.keymaps").git.fugitive,
        cmd = "G",
    },
    -- Diffview
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewFileHistory",
        },
        opts = {},
        keys = {
            {
                "<leader>gdd",
                function()
                    vim.cmd("DiffviewOpen")
                end,
                desc = "Diff",
            },
        },
    },
}
