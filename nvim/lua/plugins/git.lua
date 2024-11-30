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
                add = { text = "┃" },
                untracked = { text = "┃" },
                change = { text = "┃" },
                changedelete = { text = "┃" },
                delete = { text = "┃" },
                topdelete = { text = "┃" },
            },
            on_attach = function(buffer)
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                local gs = package.loaded.gitsigns
                local tsrm = require("nvim-treesitter.textobjects.repeatable_move")
                local next_hunk = function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end
                local prev_hunk = function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end
                local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(next_hunk, prev_hunk)

                map("n", "]g", function()
                    next_hunk_repeat({ preview = true })
                end, "Next Hunk")
                map("n", "[g", function()
                    prev_hunk_repeat({ preview = true })
                end, "Prev Hunk")
                map("n", "H", "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk")
                map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Git stage hunk")
                map("n", "<leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer")
                map({ "n", "v" }, "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
                map("n", "<leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer")
                map({ "n", "v" }, "<leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk")
                map("n", "<leader>gd", "<Cmd>Gitsigns diffthis<CR>", "Diff")
                map("n", "<leader>gb", function()
                    gs.blame_line({ full = true })
                end, "Git blame_line")
            end,
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)
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
                require("myplugins.util.init").input("Branch name", function(input)
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
        cmd = { "G", "Git", "Gvdiffsplit" },
    },
    { "akinsho/git-conflict.nvim", opts = {} },
}
