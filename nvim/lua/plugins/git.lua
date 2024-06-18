return {
    -- Git decorations and buffer integration.
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            max_file_length = 50000,
            attach_to_untracked = true,
            sign_priority = 100,
            signs_staged_enable = false,
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
    {
        "tpope/vim-fugitive",
        keys = {
            -- Git menu.
            {
                "<leader>gg",
                "<Cmd>G ++curwin<CR>",
                desc = "Git",
            },
            -- Git add.
            {
                "<leader>gaa",
                "<Cmd>G ++curwin add -v --patch<CR>",
                desc = "Git add patch",
            },
            -- Git log.
            {
                "<leader>glo",
                "<Cmd>G ++curwin log -n 200<CR>",
                desc = "Git log 100",
            },
            -- Git log.
            {
                "<leader>glc",
                "<Cmd>Telescope git_bcommits<CR>",
                desc = "Git log branch commit",
            },
            {
                "<leader>glC",
                "<Cmd>Telescope git_commits<CR>",
                desc = "Git log all commits",
            },
            -- Git commit/checkout.
            {
                "<leader>gca",
                "<Cmd>G ++curwin commit -v --amend<CR>",
                desc = "Git commit amend",
            },
            {
                "<leader>gcb",
                require("util.init").input("Branch name", function(input)
                    vim.cmd("G checkout -b " .. input)
                end),
                desc = "Git checkout new branch",
            },
            {
                "<leader>gcc",
                "<Cmd>G ++curwin commit -v<CR>",
                desc = "Git commit",
            },
            {
                "<leader>gcm",
                "<Cmd>T gcm<CR>",
                desc = "Git checkout master",
            },
            {
                "<leader>gcn",
                "<Cmd>G ++curwin commit -v --amend --no-edit<CR>",
                desc = "Git commit amend no-edit",
            },
            -- Git pull/push.
            {
                "<leader>gpf",
                "<Cmd>G push -v --force-with-lease<CR>",
                desc = "Force push",
            },
            {
                "<leader>gpl",
                "<Cmd>G pull -v<CR>",
                desc = "Git pull",
            },
            {
                "<leader>gpp",
                "<Cmd>G push -v<CR>",
                desc = "Push",
            },
            {
                "<leader>gyo",
                ":GitUrlOpen<CR>",
                desc = "Git open link",
                mode = { "n", "v" },
            },
            {
                "<leader>gyy",
                ":GitUrlCopy<CR>",
                desc = "Git copy link",
                mode = { "n", "v" },
            },
        },
        cmd = { "G", "Git" },
    },
    {
        "akinsho/git-conflict.nvim",
        lazy = true,
    },
}
