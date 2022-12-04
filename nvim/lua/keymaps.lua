local wk = require("which-key")
local t = require("telescope.builtin")
local spectre = require("spectre")
local utils = require("utils")
local cmd = vim.cmd

local keymaps = {
    ["#"] = {
        { ":let @/='\\<'.expand('<cword>').'\\>' | set hls <CR>", "Search word without jumping" },
        { function() cmd([[let @/="]] .. utils.get_visual_selection() .. [["]] .. [[ | set hls]]) end, "Search word without jumping", mode = "v" }
    },

    ["//"] = { ":nohlsearch<CR>", "Turn off highlight" },

    ["<"] = { "<gv", "Indent left", mode = "v" },
    [">"] = { ">gv", "Indent right", mode = "v" },

    ["p"] = { [["_dP]], "Replace without yanking", mode = "v" },
    ["c"] = { [["_c]], "Change without yanking", mode = { "n", "v" } },
    ["C"] = { [["_C]], "Change without yanking", mode = { "n", "v" } },

    ["k"] = { "v:count == 0 ? 'gk' : 'k'", "Up lines wrap", expr = true },
    ["j"] = { "v:count == 0 ? 'gj' : 'j'", "Down lines wrap", expr = true },

    ["ZA"] = { "<Cmd>qa!<CR>", "Force quit all" },
    ["ZS"] = { "<Cmd>wall!<CR>", "Force save all" },

    ["<CR>"] = { "m`o<Esc>``", "Insert space below cursor" },
    ["<S-CR>"] = { "m`O<Esc>``", "Insert space under cursor" },

    -- Fast shortucts
    ["<C-m>"] = { "<Cmd>Telescope resume<CR>", "Telescope resume" },
    ["<C-s>"] = {
        { "<Cmd>Telescope live_grep<CR>", "Live grep" },
        { function() t.live_grep({ default_text = utils.get_visual_selection() }) end, "Live grep", mode = "v" },
    },
    ["<C-f>"] = {
        { "<Cmd>Telescope find_files<CR>", "Find files" },
        { function() t.find_files({ default_text = utils.get_visual_selection() }) end, "Find files", mode = "v" },
    },
    ["<C-n>"] = { function() t.find_files({ default_text = utils.get_cur_buf_dir_rel_path() }) end, "Show current dir" },
    ["<C-b>"] = { "<Cmd>Telescope buffers<CR>", "Current buffers" },
    ["<C-g>"] = { "<Cmd>Telescope git_status<CR>", "Git status" },
    ["<C-1>"] = {
        { "<Cmd>ToggleTermSendCurrentLineNoTW 1<CR>", "Send line to term 1" },
        { ":ToggleTermSendVisualSelectionNoTW 1<CR>", "Send visual selection to term 1", mode = "v" },
    },
    ["<C-2>"] = {
        { "<Cmd>ToggleTermSendCurrentLineNoTW 2<CR>", "Send line to term 2" },
        { ":ToggleTermSendVisualSelectionNoTW 2<CR>", "Send visual selection to term 2" }
    },
    ["<C-[>"] = { "<C-\\><C-n>", "Normal mode", mode = "t" },

    ["<C-k>"] = { "<C-w><Up>", "Go to upper window" },
    ["<C-j>"] = {
        { "<C-w><down>", "Go to bottom window" },
        { "<C-^>", "Switch layout", mode = { "i", "c", "t" } }
    },
    ["<C-l>"] = { "<C-w><right>", "Go to right window" },
    ["<C-h>"] = { "<C-w><Left>", "Go to left window" },

    ["<C-Up>"] = { "<Cmd>resize -2<CR>", "Resize horiz-" },
    ["<C-Down>"] = { "<Cmd>resize +2<CR>", "Resize horiz+" },
    ["<C-Left>"] = { "<Cmd>vertical resize -2<CR>", "Resize vert-" },
    ["<C-Right>"] = { "<Cmd>vertical resize +2<CR>", "Resize vert+" },

    ["C-w"] = {
        name = "+window",
        ["b"] = { ":bd! %<CR>", "Close current buffer" },
    },

    ["yo"] = {
        name = "+setoption",
        ["s"] = { "<Cmd>set invspell<CR>", "Set spelling" },
        ["c"] = { "<Cmd>SetColorColumn<CR>", "Set vert limit bar" }
    },

    ["["] = {
        name = "+prevaction",
        ["b"] = { "<Cmd>bprev<CR>", "Prev buffer" },
        ["t"] = { "<Cmd>tabprevious<CR>", "Next tab" },
        ["g"] = { "<Cmd>Gitsigns prev_hunk<CR>", "Prev Git hunk" },
        ["q"] = { "<Cmd>cprev<CR>", "Prev item in qf" },
        ["<leader>"] = { "i<leader><Esc>", "Insert space after cursor" },
    },
    ["]"] = {
        name = "+nextaction",
        ["b"] = { "<Cmd>bnext<CR>", "Next buffer" },
        ["t"] = { "<Cmd>tabnext<CR>", "Next tab" },
        ["g"] = { "<Cmd>Gitsigns next_hunk<CR>", "Next git hunk" },
        ["q"] = { "<Cmd>cnext<CR>", "Next item in qf" },
        ["<leader>"] = { "a<leader><Esc>", "Insert space under cursor" },
    },

    ["il"] = {
        { ":normal ^vg_<CR>", "Line textobject", mode = "v" },
        { ":normal vil<CR>", "Line textobject", mode = "o" }
    },

    ["al"] = {
        { ":normal 0v$h<CR>", "Line textobject", mode = "v" },
        { ":normal val<CR>", "Line textobject", mode = "o" }
    },

    ["<leader>"] = {
        name = "+SPC",
        ["<leader>"] = { "<Cmd>NeoTreeRevealToggle<CR>", "Open file explorer" },

        ["r"] = {
            name = "+repeat",
            ["e"] = { "@:", "Repeat last command" }
        },

        ["s"] = {
            name = "+search",
            ["o"] = { function() t.oldfiles({ only_cwd = true }) end, "Search recent files" },
            ["b"] = {
                { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Search buffer" },
                { function() t.current_buffer_fuzzy_find({ default_text = utils.get_visual_selection() }) end, "Search buffer", mode = "v" },
            },
            ["s"] = {
                { function()
                    vim.ui.input(
                        "Grep string",
                        function(input)
                            if not input then
                                return
                            end
                            require("telescope.builtin").grep_string({ search = input })
                        end)
                end,
                    "Search string"
                },
                { function() t.grep_string({ default_text = utils.get_visual_selection() }) end, "Search string", mode = "v" },
            }
        },

        ["e"] = {
            name = "+edit",
            ["s"] = { function() spectre.open_file_search() end, "Search and replace" },
            ["S"] = { function() spectre.open() end, "Search and replace" },
        },

        ["o"] = {
            name = "+open",
            ["a"] = { "<Cmd>$tabnew | Alpha<CR>", "Open dashboard" },
            ["1"] = { "<Cmd>1ToggleTerm direction=float<CR>", "Toggle term1" },
            ["2"] = { "<Cmd>2ToggleTerm direction=vertical<CR>", "Toggle term2" },
            ["m"] = { "<Cmd>MarkdownPreviewToggle<CR>", "Toggle markdown preview" },
            ["q"] = { "<Cmd>copen<CR>", "Open quick fix list" },
            ["t"] = { "<Cmd>$tabnew %<CR>", "Open tab for current buffer" },
        },

        ["h"] = {
            name = "+help",
            ["c"] = { "<Cmd>Telescope commands<CR>", "Commands" },
            ["h"] = { "<Cmd>Telescope help_tags<CR>", "Help pages" },
            ["k"] = { "<Cmd>Telescope keymaps<CR>", "Key maps" },
            ["m"] = { "<Cmd>Telescope man_pages<CR>", "Man pages" },
            ["f"] = { "<Cmd>Telescope filetypes<CR>", "File Types" },
            ["t"] = { "<Cmd>Telescope builtin<CR>", "Telescope" },
            ["s"] = { "<Cmd>Telescope highlights<cr>", "Search Highlight Groups" },
            ["o"] = { "<Cmd>Telescope vim_options<CR>", "Options" },
            ["p"] = { "<Cmd>PackerCompile<CR>", "Packer compile" },
        },

        ["g"] = {
            name = "+git",
            ["l"] = { ":GitLog<CR>", "Git log", mode = { "n", "v" } },
            ["y"] = {
                { function() require "gitlinker".get_buf_range_url("n") end, "Git copy link" },
                { function() require "gitlinker".get_buf_range_url("v") end, "Git copy link" },
            },
            ["b"] = { "<Cmd>Gitsigns blame_line<CR>", "Git blame_line" },
            ["d"] = { "<Cmd>Gitsigns diffthis<CR>", "Git diff" },
            ["h"] = { "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk" },
            ["i"] = { "<Cmd>GitShow<CR>", "Git show" },
            ["v"] = { "<Cmd>Gitsigns select_hunk<CR>", "Git select hunk" },
            ["r"] = { "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk" },
            ["R"] = { "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer" },
            ["s"] = { "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk" },
            ["S"] = { "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer" },
            ["u"] = { "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk" },
            ["o"] = {
                name = "+open",
                ["s"] = { "<Cmd>Telescope git_stash<CR>", "Git stash" },
                ["c"] = { "<Cmd>Telescope git_commits<CR>", "Git commits" },
                ["b"] = { "<Cmd>Telescope git_branches<CR>", "Git branches" },
            }
        },

    }
}

wk.register(keymaps)
