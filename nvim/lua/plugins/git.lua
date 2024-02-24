return {
    -- Git decorations and buffer integration.
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            max_file_length = 50000,
            attach_to_untracked = true,
            _signs_staged_enable = true,
            sign_priority = 100,
            _signs_staged = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "┃" },
                topdelete = { text = "┃" },
                changedelete = { text = "┃" },
            },
            signs = {
                add = { hl = "GitSignsAdd", text = "┃" },
                untracked = { hl = "GitSignsAdd", text = "┃" },
                change = { hl = "GitSignsChange", text = "┃" },
                changedelete = { hl = "GitSignsChange", text = "┃" },
                delete = { hl = "GitSignsDelete", text = "┃" },
                topdelete = { hl = "GitSignsDelete", text = "┃" },
            },
            on_attach = function(buffer)
                local k = require("config.keymaps")
                k.git.signs(buffer)
            end,
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
            require("git-conflict").setup({
                highlights = {
                    ancestor = "DiffChange",
                },
                default_mappings = {
                    next = "]x",
                    prev = "[x",
                },
            })
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
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        lazy = true,
    },
}
