local Util = function()
    return require("util.init")
end

local UtilBuf = function()
    return require("util.buf")
end

local UtilVisual = function()
    return require("util.visual")
end

return {
    core = function()
        local map = vim.keymap.set
        map("n", "<leader>s", "<CMD>w!<CR>", { desc = "Save file" })
        -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
        map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
        map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
        map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
        map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
        map("n", "ZA", "<Cmd>wqall!<CR>", { desc = "Force quit all" })
        -- Package manager.
        map("n", "<leader>pp", "<Cmd>Lazy home<CR>", { desc = "Plugins" })
        -- Search without jumping.
        map("n", "#", function()
            local text = vim.fn.expand("<cword>")
            vim.fn.setreg("/", text)
            vim.cmd("set hls")
        end, { desc = "Search word without jumping", silent = true })
        -- Turn off highlight.
        map("n", "//", ":nohlsearch<CR>", { desc = "Turn off highlight" })
        -- Better up/down.
        map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Up with line wrap", expr = true, silent = true })
        map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Down with line wrap", expr = true, silent = true })
        map({ "i", "c" }, "<C-h>", "<Left>", { desc = "Go to left window" })
        map({ "i", "c" }, "<C-l>", "<Right>", { desc = "Go to right window" })
        map("n", "<C-h>", "<C-w><Left>", { desc = "Go to left window" })
        -- Better start/end
        map({ "n", "v" }, ")", "$", { desc = "To the end line" })
        map({ "n", "v" }, "(", "^", { desc = "To the start of line" })
        -- Move Lines
        map("n", "<A-j>", "<Cmd>m .+1<CR>==", { desc = "Move down" })
        map("n", "<A-k>", "<Cmd>m .-2<CR>==", { desc = "Move up" })
        map("i", "<A-j>", "<Esc><Cmd>m .+1<CR>==gi", { desc = "Move down" })
        map("i", "<A-k>", "<Esc><Cmd>m .-2<CR>==gi", { desc = "Move up" })
        map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
        map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
        -- Better scroll.
        map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with center" })
        map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
        -- Better indent.
        map("v", "<", "<gv")
        map("v", ">", ">gv")
        -- Follow line number with `gf`.
        map({ "n", "v" }, "gf", "gF")
        map({ "n", "v" }, "gF", "gf")
        -- New lines.
        map("n", "<CR>", "m`o<Esc>``", { desc = "Insert new line below cursor" })
        map("n", "<S-CR>", "m`O<Esc>``", { desc = "Insert new line under cursor" })
        -- Close buffer.
        map("n", "<C-w>b", ":bd! %<CR>", { desc = "Close current buffer" })
        map("n", "<C-w>t", "<Cmd>tabc<CR>", { desc = "Close current tab" })
        -- Without yank.
        map("v", "p", [["_dP]], { desc = "Replace without yanking" })
        map({ "n", "v" }, "c", [["_c]], { desc = "Change without yanking" })
        map({ "n", "v" }, "C", [["_C]], { desc = "Change without yanking" })
        -- Terminal
        map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Normal mode" })
        map("t", "<C-w>c", "<C-\\><C-n><C-w>c", { desc = "Close terminal" })
        map("t", "<C-u>", "<C-\\><C-n><C-u>", { desc = "Scroll up" })
        map({ "n", "t" }, [[<C-\>]], "<Cmd>TermToggleFloat<CR>")
        map("n", "<leader>ot", "<Cmd>TermToggleVsplit<CR>")
        map({ "n", "v" }, "<C-2>", ":TermSend<CR>")
        map("n", "<C-3>", "<Cmd>TermSend q<CR>")
        map("n", "<C-->", "<Cmd>TermSend <Up><CR>")
        map("n", "<C-=>", "<Cmd>TermSend <Down><CR>")
        map("n", "<C-0>", "<Cmd>TermSend <CR>")
        -- Windows.
        map("n", "<C-k>", "<C-w><Up>", { desc = "Go to upper window" })
        map("n", "<C-j>", "<C-w><down>", { desc = "Go to bottom window" })
        map("n", "<C-l>", "<C-w><right>", { desc = "Go to right window" })
        map("n", "<C-h>", "<C-w><Left>", { desc = "Go to left window" })
        map("n", "<C-Up>", "<Cmd>resize -2<CR>", { desc = "Resize horiz-" })
        map("n", "<C-Down>", "<Cmd>resize +2<CR>", { desc = "Resize horiz+" })
        map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Resize vert-" })
        map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Resize vert+" })
        -- Set options and misc.
        map("n", "yos", "<Cmd>setlocal invspell<CR>", { desc = "Set spelling" })
        map("n", "yoc", "<Cmd>SetColorColumn<CR>", { desc = "Set vert limit bar" })
        map("n", "yol", "<Cmd>set invrelativenumber<CR>", { desc = "Toggle relative number" })
        map("n", "yof", UtilBuf().copy_rel_path_to_buffer, { desc = "Yank file path" })
        map("n", "yoF", UtilBuf().copy_rel_path_line_to_buffer, { desc = "Yank file path with line" })
        -- Prev action.
        map("n", "[b", ":bprev<CR>", { desc = "Prev buffer" })
        map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
        -- Run commands.
        map({ "n", "v" }, "<leader>ru", ":Run<CR>", { desc = "Run current file" })
        map("n", "<leader>re", ":TermRespawn<CR>", { desc = "Respawn last term" })
        map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
        -- Spacing.
        map("n", "]<leader>", "<Cmd>norm i <CR>l", { desc = "Next buffer" })
        map("n", "[<leader>", "<Cmd>norm x <CR>hvp", { desc = "Next tab" })
        -- Mind.
        -- map("n", "<leader>mt", "<Cmd>e ~/mind/todo/current.md<CR>", { desc = "Open todo in mind" })
        -- map("n", "<leader>mf", "<Cmd>Telescope find_files cwd=~/mind<CR>", { desc = "Find files in mind" })
        -- map("n", "<leader>ms", "<Cmd>Telescope live_grep cwd=~/mind<CR>", { desc = "Live grep in mind" })
        -- Language specific
        map("n", "<leader>ng", function()
            vim.cmd("e ~/workspace/scratch/main.go")
        end, { desc = "Scratch" })
    end,
    git = {
        signs = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end
            local gs = package.loaded.gitsigns
            -- Blame.
            map("n", "<leader>gb", function()
                gs.blame_line({ full = true })
            end, "Git blame_line")
            -- Hunks.
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
        end,
    },
    telescope = function()
        local t = function()
            return require("telescope.builtin")
        end

        return {
            -- Search.
            {
                "<C-/>",
                "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
                desc = "Search buffer",
            },
            {
                "<C-/>",
                function()
                    t().current_buffer_fuzzy_find({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                end,
                desc = "Search buffer",
                mode = "v",
            },
            {
                "<C-m>",
                "<Cmd>Telescope resume<CR>",
                desc = "Telescope resume",
            },
            {
                "<C-n>",
                function()
                    t().find_files({ default_text = UtilBuf().get_cur_buf_dir_rel_path() })
                end,
                desc = "Show current dir",
            },
            {
                "<C-b>",
                "<Cmd>Telescope buffers<CR>",
                desc = "Current buffers",
            },
            {
                "<C-f>",
                "<Cmd>Telescope find_files<CR>",
                desc = "Find files",
            },
            {
                "<C-f>",
                function()
                    t().find_files({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                end,
                desc = "Find files",
                mode = "v",
            },
            {
                "<C-s>",
                "<Cmd>Telescope live_grep<CR>",
                desc = "Live grep",
            },
            {
                "<C-s>",
                function()
                    t().live_grep({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                end,
                desc = "Live grep",
                mode = "v",
            },
            {
                "<C-;>",
                "<Cmd>Telescope command_history<CR>",
                desc = "Command history",
            },
            -- Git
            {
                "<C-g>",
                "<Cmd>silent! Telescope git_status<CR>",
                desc = "Git status",
            },
            {
                "<leader>gco",
                "<Cmd>Telescope git_branches<CR>",
                desc = "Git checkout",
            },
            {
                "<leader>gos",
                "<Cmd>Telescope git_stash<CR>",
                desc = "Git stash",
            },
            {
                "<leader>goc",
                "<Cmd>Telescope git_commits<CR>",
                desc = "Git commits",
            },
            {
                "<leader>goC",
                "<Cmd>Telescope git_bcommits<CR>",
                desc = "Git commits",
            },
            {
                "<leader>gob",
                function()
                    t().git_branches({ show_remote_tracking_branches = false })
                end,
                desc = "Git branches",
            },
            {
                "<leader>goB",
                function()
                    t().git_branches()
                end,
                desc = "Git branches all",
            },
            -- Help
            {
                "<leader>hc",
                "<Cmd>Telescope commands<CR>",
                desc = "Commands",
            },
            {
                "<leader>hh",
                "<Cmd>Telescope help_tags<CR>",
                desc = "Help pages",
            },
            {
                "<leader>hk",
                "<Cmd>Telescope keymaps<CR>",
                desc = "Key maps",
            },
            {
                "<leader>hm",
                "<Cmd>Telescope man_pages<CR>",
                desc = "Man pages",
            },
            {
                "<leader>hf",
                "<Cmd>Telescope filetypes<CR>",
                desc = "File Types",
            },
            {
                "<leader>ht",
                "<Cmd>Telescope builtin<CR>",
                desc = "Telescope",
            },
            {
                "<leader>hs",
                "<Cmd>Telescope highlights<cr>",
                desc = "Search Highlight Groups",
            },
            {
                "<leader>ho",
                "<Cmd>Telescope vim_options<CR>",
                desc = "Options",
            },
            -- Open
            {
                "<leader>oc",
                "<Cmd>Telescope find_files cwd=~/dotfiles<CR>",
                desc = "Open configs dir",
            },
            {
                "<leader>op",
                "<Cmd>Telescope find_files cwd=~/private<CR>",
                desc = "Open private dir",
            },
            {
                "<leader>o/",
                "<Cmd>Telescope search_history<CR>",
                desc = "Search history",
            },
            {
                "<leader>or",
                function()
                    t().oldfiles({ only_cwd = true })
                end,
                desc = "Open recent files",
            },
            {
                "<leader>od",
                "<Cmd>Telescope diagnostics<CR>",
                desc = "Diagnostics",
            },
            {
                "<leader>oy",
                "<Cmd>YAMLTelescope<CR>",
                desc = "Open yaml strings",
            },
            {
                "<leader>os",
                Util().input("Grep string", function(input)
                    t().grep_string({ search = input })
                end),
                desc = "Grep string",
            },
            {
                "<leader>os",
                function()
                    t().grep_string({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                end,
                desc = "Grep string",
                mode = "v",
            },
            {
                "<leader>ou",
                "<Cmd>Telescope undo<CR>",
                desc = "Undo history",
            },
        }
    end,
}
