local wk = require("which-key")
local utils = require("utils")
local t = require("telescope.builtin")

vim.keymap.set("n", "<leader>rt", "<Cmd>1ToggleTerm direction=float<CR>")
vim.keymap.set("n", "<leader>rl", "<Cmd>2ToggleTerm direction=vertical<CR>")
vim.keymap.set("n", "<C-s>", "<Cmd>ToggleTermSendCurrentLineNoTW 2<CR>")
vim.keymap.set("v", "<C-s>", ":ToggleTermSendVisualSelectionNoTW 2<CR>")

local n_keymaps = {
    ["#"] = { ":let @/= '\\<'.expand('<cword>').'\\>' | set hls <CR>", "Search word without jumping" },

    ["//"] = { ":nohlsearch<CR>", "Turn off highlight" },

    ["c"] = { [["_c]], "Change without yanking" },
    ["C"] = { [["_C]], "Change without yanking" },

    ["k"] = { "v:count == 0 ? 'gk' : 'k'", "Up lines wrap", expr = true },
    ["j"] = { "v:count == 0 ? 'gj' : 'j'", "Down lines wrap", expr = true },

    ["Z"] = {
        name = "+quit",
        ["A"] = { "<Cmd>qa!<CR>", "Force quit all" },
    },

    ["<CR>"] = { "m`o<Esc>``", "Insert space below cursor" },
    ["<S-CR>"] = { "m`O<Esc>``", "Insert space under cursor" },

    -- Fast shortucts
    ["<C-n>"] = { function() t.find_files({ default_text = utils.get_cur_buf_dir_rel_path() }) end, "Show current dir" },
    ["<C-f>"] = { "<Cmd>Telescope find_files<CR>", "Find files" },
    ["<C-b>"] = { "<Cmd>Telescope buffers<CR>", "Current buffers" },
    ["<C-g>"] = { "<Cmd>Telescope git_status<CR>", "Git status" },

    ["<C-k>"] = { "<C-w><Up>", "Go to upper window" },
    ["<C-j>"] = { "<C-w><down>", "Go to bottom window" },
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
        ["b"] = { "<Cmd>bprev<CR>", "Next buffer" },
        ["g"] = { "<Cmd>Gitsigns prev_hunk<CR>", "Git prev hunk" },
        ["q"] = { "<Cmd>cprev<CR>", "Prev item in qf" },
        ["<leader>"] = { "i<leader><Esc>", "Insert space after cursor" },
    },
    ["]"] = {
        name = "+nextaction",
        ["b"] = { "<Cmd>bnext<CR>", "Previous buffer" },
        ["g"] = { "<Cmd>Gitsigns next_hunk<CR>", "Git next hunk" },
        ["q"] = { "<Cmd>cnext<CR>", "Next item in qf" },
        ["<leader>"] = { "a<leader><Esc>", "Insert space under cursor" },
    },

    ["<leader>"] = {
        name = "+SPC",
        ["<leader>"] = { "<Cmd>NeoTreeRevealToggle<CR>", "Open file explorer" },


        ["c"] = {
            name = "+create",
            ["t"] = { "<Cmd>$tabnew %<CR>", "Create tab for current buffer" }
        },

        ["g"] = {
            name = "+git",
            ["b"] = { "<Cmd>Gitsigns blame_line<CR>", "Git blame_line" },
            ["d"] = { "<Cmd>Gitsigns diffthis<CR>", "Git diff" },
            ["h"] = { "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk" },
            ["i"] = { "<Cmd>GitShow<CR>", "Git show" },
            ["l"] = { "<Cmd>GitLog<CR>", "Git log" },
            ["v"] = { "<Cmd>Gitsigns select_hunk<CR>", "Git select hunk" },
            ["r"] = { "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk" },
            ["s"] = { "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk" },
            ["u"] = { "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk" },
            ["x"] = { "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer" },
            ["y"] = { function() require "gitlinker".get_buf_range_url("n") end, "Git copy link" }
        },

        ["v"] = {
            name = "+files",
            ["p"] = { "<Cmd>vsp ~/private/nvim/init.lua<CR>", "" },
            ["s"] = { "<Cmd>source $MYVIMRC<CR>", "Source vim config" },
        },

        ["r"] = {
            name = "+?",
            ["e"] = { "@:", "Repeat last command" }
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
    }
}

local v_keymaps = {
    ["p"] = { [["_dP]], "Replace without yanking" },

    ["c"] = { [["_c]], "Change without yanking" },
    ["C"] = { [["_C]], "Change without yanking" },

    ["il"] = { ":normal ^vg_<CR>", "Line textobject" },
    ["al"] = { ":normal 0v$h<CR>", "Line textobject" },
    ["<"]  = { "<gv", "Indent left" },
    [">"]  = { ">gv", "Indent right" },

    ["<C-f>"] = { function() t.find_files({ default_text = utils.get_visual_selection() }) end, "Find files" },

    ["<leader>"] = {
        name = "+SPC",
        ["g"] = {
            name = "+git",
            ["l"] = { ":GitLog<CR>", "Git log selected" },
            ["y"] = { function() require "gitlinker".get_buf_range_url("v") end, "Git copy link" }
        }
    }
}

local i_keymaps = {
    ["<C-j>"] = { "<C-^>", "Switch layout" },
}

local t_keymaps = {
    ["<C-[>"] = { "<C-\\><C-n>", "Switch layout" },
}

local c_keymaps = {
    ["<C-j>"] = { "<C-^>", "Switch layout" },
}

local o_keymaps = {
    ["il"] = { ":normal vil", "Line textobject" },
    ["al"] = { ":normal val", "Line textobject" },
}


wk.register(n_keymaps, { mode = "n" })
wk.register(v_keymaps, { mode = "v" })
wk.register(i_keymaps, { mode = "i" })
wk.register(t_keymaps, { mode = "t" })
wk.register(c_keymaps, { mode = "c" })
wk.register(o_keymaps, { mode = "o" })
