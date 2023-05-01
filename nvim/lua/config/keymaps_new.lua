return {
    core             = function()
        local f = require("functions")
        local map = vim.keymap.set

        map("n", "#", ":let @/='\\<'.expand('<cword>').'\\>' | set hls <CR>", { desc = "Search word without jumping" })
        map("v", "#", function() vim.cmd([[let @/="]] .. f.vim.get_visual_selection() .. [["]] .. [[ | set hls]]) end, { desc = "Search word without jumping" })

        map("n", "//", ":nohlsearch<CR>", { desc = "Turn off highlight" })

        map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Up with line wrap", expr = true, silent = true })
        map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Down with line wrap", expr = true, silent = true })

        map("n", "<CR>", "m`o<Esc>``", { desc = "Insert space below cursor" })
        map("n", "<S-CR>", "m`O<Esc>``", { desc = "Insert space under cursor" })

        map("v", "p", [["_dP]], { desc = "Replace without yanking" })
        map({ "n", "v" }, "c", [["_c]], { desc = "Change without yanking" })
        map({ "n", "v" }, "C", [["_C]], { desc = "Change without yanking" })
    end,
    luasnip          = function()
        return {
            {
                "<C-f>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            { "<C-f>", function() require("luasnip").jump(1) end,  mode = "s" },
            { "<C-d>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        }
    end,
    mini             = {
        surround = function()
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            return {
                { opts.mappings.add,            desc = "Add surrounding",        mode = { "n", "v" } },
                { opts.mappings.delete,         desc = "Delete surrounding" },
                { opts.mappings.replace,        desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `coverage lines`" },
            }
        end
    },
    spectre          = function()
        return {
            { "<leader>s", function() require("spectre").open() end,             desc = "Search and replace" },
            { "<leader>S", function() require("spectre").open_file_search() end, desc = "Search and replace current file" },
        }
    end,
    markdown_preview = function()
        return {
            { "<leader>om", "<Cmd>MarkdownPreviewToggle<CR>", desc = "Toggle markdown preview" },
        }
    end,
    undotree         = function()
        return {
            { "<leader>ou", "<Cmd>UndotreeToggle<CR>", desc = "Undo tree" },
        }
    end,
    git              = {
        default = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- Git log
            map({ "n", "v" }, "<leader>gll", ":GitLog<CR>", "Git log")
            map("n", "<leader>glg", "<Cmd>GitLogG<CR>", "Git log global")

            -- Git show
            map("n", "<leader>gi", "<Cmd>GitShow<CR>", "Git show")
        end,
        signs = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            local gs = package.loaded.gitsigns
            local tsrm = require "nvim-treesitter.textobjects.repeatable_move"
            local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

            map("n", "]g", next_hunk_repeat, "Next Hunk")
            map("n", "[g", prev_hunk_repeat, "Prev Hunk")
            map("n", "<leader>gb", "<Cmd>Gitsigns blame_line<CR>", "Git blame_line")
            map("n", "<leader>gd", "<Cmd>Gitsigns diffthis<CR>", "Git diff")
            map("n", "<leader>gh", "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk")
            map("n", "<leader>gv", "<Cmd>Gitsigns select_hunk<CR>", "Git select hunk")
            map("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
            map("n", "<leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer")
            map("n", "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk")
            map("n", "<leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer")
            map("n", "<leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk")
        end,
        fugitive = function()
            return {
                { "<leader>gg",  "<Cmd>vert G<CR>",                             desc = "Git" },
                { "<leader>glo", "<Cmd>vert G log -n 1000<CR>",                 desc = "Git log 1000" },
                { "<leader>gaa", "<Cmd>vert G add -v --patch<CR>",              desc = "Git add patch" },
                { "<leader>gcc", "<Cmd>vert G commit -v<CR>",                   desc = "Git commit" },
                { "<leader>gca", "<Cmd>vert G commit -v --amend<CR>",           desc = "Git commit amend" },
                { "<leader>gcn", "<Cmd>vert G commit -v --amend --no-edit<CR>", desc = "Git commit amend no-edit" },
                { "<leader>gpp", "<Cmd>G push -v<CR>",                          desc = "Push" },
                { "<leader>gpf", "<Cmd>G push -v --force-with-lease<CR>",       desc = "Force push" },
                { "<leader>gpl", "<Cmd>G pull -v<CR>",                          desc = "Git pull" },
            }
        end,
        linker = function()
            local gitlinker = require("gitlinker")

            return {
                { "<leader>gy", function() gitlinker.get_buf_range_url("n") end, desc = "Git copy link" },
                { "<leader>gy", function() gitlinker.get_buf_range_url("v") end, desc = "Git copy link", mode = "v" }
            }
        end,
    },
    neotree          = function()
        return {
            { "<C-Space>", "<Cmd>Neotree position=current reveal=true toggle=true<CR>", desc = "Open file explorer" }
        }
    end,
    telescope        = function()
        local f = require("functions")
        local t = require("telescope.builtin")

        return {
            -- Core
            { "<C-/>",       "<Cmd>Telescope current_buffer_fuzzy_find<CR>",                                              desc = "Search buffer" },
            { "<C-/>",       function() t.current_buffer_fuzzy_find({ default_text = f.vim.get_visual_selection() }) end, desc = "Search buffer",          mode = "v" },
            { "<C-/>" },
            { "<C-m>",       "<Cmd>Telescope resume<CR>",                                                                 desc = "Telescope resume" },
            { "<C-n>",       function() t.find_files({ default_text = f.vim.get_cur_buf_dir_rel_path() }) end,            desc = "Show current dir" },
            { "<C-b>",       "<Cmd>Telescope buffers<CR>",                                                                desc = "Current buffers" },
            { "<C-f>",       "<Cmd>Telescope find_files<CR>",                                                             desc = "Find files" },
            { "<C-f>",       function() t.find_files({ default_text = f.vim.get_visual_selection() }) end,                desc = "Find files",             mode = "v" },
            { "<C-s>",       "<Cmd>Telescope live_grep<CR>",                                                              desc = "Live grep" },
            { "<C-s>",       function() t.live_grep({ default_text = f.vim.get_visual_selection() }) end,                 desc = "Live grep",              mode = "v" },
            -- Git
            { "<C-g>",       "<Cmd>Telescope git_status<CR>",                                                             desc = "Git status" },
            { "<leader>gos", "<Cmd>Telescope git_stash<CR>",                                                              desc = "Git stash" },
            { "<leader>goc", "<Cmd>Telescope git_commits<CR>",                                                            desc = "Git commits" },
            { "<leader>goC", "<Cmd>Telescope git_bcommits<CR>",                                                           desc = "Git commits" },
            { "<leader>gob", "<Cmd>Telescope git_branches<CR>",                                                           desc = "Git branches" },
            -- Help
            { "<leader>hc",  "<Cmd>Telescope commands<CR>",                                                               desc = "Commands" },
            { "<leader>hh",  "<Cmd>Telescope help_tags<CR>",                                                              desc = "Help pages" },
            { "<leader>hk",  "<Cmd>Telescope keymaps<CR>",                                                                desc = "Key maps" },
            { "<leader>hm",  "<Cmd>Telescope man_pages<CR>",                                                              desc = "Man pages" },
            { "<leader>hf",  "<Cmd>Telescope filetypes<CR>",                                                              desc = "File Types" },
            { "<leader>ht",  "<Cmd>Telescope builtin<CR>",                                                                desc = "Telescope" },
            { "<leader>hs",  "<Cmd>Telescope highlights<cr>",                                                             desc = "Search Highlight Groups" },
            { "<leader>ho",  "<Cmd>Telescope vim_options<CR>",                                                            desc = "Options" },
            -- Open
            { "<leader>oc",  "<Cmd>Telescope find_files cwd=~/dotfiles<CR>",                                              desc = "Open configs dir" },
            { "<leader>op",  "<Cmd>Telescope find_files cwd=~/private<CR>",                                               desc = "Open private dir" },
            { "<leader>or",  function() t.oldfiles({ only_cwd = true }) end,                                              desc = "Open recent files" },
            { "<leader>od",  "<Cmd>Telescope diagnostics<CR>",                                                            desc = "Diagnostics" },
            -- Other
            { "<leader>ms",  f.vim.input("Grep string", function(input) t.grep_string({ search = input }) end),           desc = "Grep string" },
            { "<leader>ms",  function() t.grep_string({ default_text = f.vim.get_visual_selection() }) end,               desc = "Grep string",            mode = "v" },
        }
    end
}
