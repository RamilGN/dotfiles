local wk = require("which-key")

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
            ["v"] = { "<Cmd>Gitsigns stage_hunk<CR>", "Git select hunk" },
            ["r"] = { "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk" },
            ["s"] = { "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk" },
            ["u"] = { "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk" },
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

        ["t"] = {
            name = "+telescope",
            ["h"] = {
                name = "+help",
                ["h"] = "<Cmd>Telescope help_tags",
                ["c"] = "<Cmd>Telescope commands"
            }
        }
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
    ["C-j"] = { "<C-^>", "Switch layout" },
}

local t_keymaps = {
    ["C-["] = { "<C-\\><C-n>", "Switch layout" },
}


local c_keymaps = {
    ["C-j"] = { "<C-^>", "Switch layout" },
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
