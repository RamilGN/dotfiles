local vks = vim.keymap.set
local wk = require("which-key");

-- ## Change without yanking
vks("n", "c", '"_c')
vks("n", "C", '"_C')
-- ## Repeat last command
vks("n", "<leader>re", "@:")
-- ## Edit/source current config
vks("n", "<leader>vl", "<Cmd>vsp ~/dotfiles/nvim<CR>")
vks("n", "<leader>vs", "<Cmd>source $MYVIMRC<CR>")
-- ## Quit all
vks("n", "ZA", "<Cmd>qa!<CR>")
-- ## Create a new tab
vks("n", "<leader>ct", "<Cmd>$tabnew %<CR>")
local n_keymaps = {
    ["#"] = { ":let @/= '\\<'.expand('<cword>').'\\>' | set hls <CR>", "Search word without jumping" },

    ["//"] = { ":nohlsearch<CR>", "Turn off highlight" },

    ["k"] = { "v:count == 0 ? 'gk' : 'k'", "Up lines wrap", expr = true },
    ["j"] = { "v:count == 0 ? 'gj' : 'j'", "Down lines wrap", expr = true },

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
        ["g"] = {
            name = "+git",
            ["l"] = { "<Cmd>GitLog<CR>", "Git log" },
            ["i"] = { "<Cmd>GitShow<CR>", "Git show" }
        }
    }
}


-- # Line textobject
vks("v", "il", ":normal ^vg_<CR>")
vks("v", "al", ":normal 0v$h<CR>")
-- ## Change without yanking
vks("v", "C", '"_C')
vks("v", "c", '"_c')
local v_keymaps = {
    ["p"] = { [["_dP]], "Replace without yanking" },

    ["<leader>"] = {
        name = "+SPC",
        ["g"] = {
            name = "+git",
            ["l"] = { ":GitLog<CR>", "Git log selected" }
        }
    }
}

-- ## Switch layout
vks({ "c", "i" }, "<C-j>", "<C-^>")
local i_keymaps = {}

-- ## Exit terminal mode
vks("t", "<C-[>", "<C-\\><C-n>")
local t_keymaps = {}


-- ## Switch layout
vks({ "c", "i" }, "<C-j>", "<C-^>")
local c_keymaps = {}


-- # Line textobject
vks("o", "il", ":normal vil<CR>")
vks("o", "al", ":normal val<CR>")
local o_keymaps = {}


wk.register(n_keymaps, { mode = "n" })
wk.register(v_keymaps, { mode = "v" })
wk.register(i_keymaps, { mode = "i" })
wk.register(t_keymaps, { mode = "t" })
wk.register(c_keymaps, { mode = "c" })
wk.register(c_keymaps, { mode = "o" })
