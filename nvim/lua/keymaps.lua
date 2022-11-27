local wk = require("which-key")
local t = require("telescope.builtin")
local spectre = require("spectre")
local utils = require("utils")
local cmd = vim.cmd

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

local n_keymaps = {
    ["#"] = { ":let @/='\\<'.expand('<cword>').'\\>' | set hls <CR>", "Search word without jumping" },

    ["//"] = { ":nohlsearch<CR>", "Turn off highlight" },

    ["c"] = { [["_c]], "Change without yanking" },
    ["C"] = { [["_C]], "Change without yanking" },

    ["k"] = { "v:count == 0 ? 'gk' : 'k'", "Up lines wrap", expr = true },
    ["j"] = { "v:count == 0 ? 'gj' : 'j'", "Down lines wrap", expr = true },

    ["ZA"] = { "<Cmd>qa!<CR>", "Force quit all" },

    ["<CR>"] = { "m`o<Esc>``", "Insert space below cursor" },
    ["<S-CR>"] = { "m`O<Esc>``", "Insert space under cursor" },

    -- Fast shortucts
    ["<C-m>"] = { "<Cmd>Telescope resume<CR>", "Telescope resume" },
    ["<C-s>"] = { "<Cmd>Telescope live_grep<CR>", "Live grep" },
    ["<C-q>"] = { "<Cmd>Telescope lsp_document_symbols<CR>", "Live grep" },
    ["<C-n>"] = { function() t.find_files({ default_text = utils.get_cur_buf_dir_rel_path() }) end, "Show current dir" },
    ["<C-f>"] = { "<Cmd>Telescope find_files<CR>", "Find files" },
    ["<C-b>"] = { "<Cmd>Telescope buffers<CR>", "Current buffers" },
    ["<C-g>"] = { "<Cmd>Telescope git_status<CR>", "Git status" },
    ["<C-1>"] = { "<Cmd>ToggleTermSendCurrentLineNoTW 1<CR>", "Send line to term 1" },
    ["<C-2>"] = { "<Cmd>ToggleTermSendCurrentLineNoTW 2<CR>", "Send line to term 2" },

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

        ["r"] = {
            name = "+repeat",
            ["e"] = { "@:", "Repeat last command" }
        },

        ["c"] = {
            name = "+create",
            ["t"] = { "<Cmd>$tabnew %<CR>", "Create tab for current buffer" }
        },

        ["s"] = {
            name = "+search",
            ["o"] = { function() t.oldfiles({ only_cwd = true }) end, "Search recent files" },
            ["b"] = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Search buffer" },
            ["s"] = { function()
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
        },

        ["l"] = {
            name = "+LSP",
            ["d"] = { "<Cmd>Telescope diagnostics<CR>", "LSP Diagnostics" },
            ["o"] = { "<Cmd>Telescope lsp_workspace_symbols<CR>", "LSP workspace symbols" }
        },

        ["e"] = {
            name = "+edit",
            ["s"] = { function() spectre.open_file_search() end, "Search and replace" },
            ["S"] = { function() spectre.open() end, "Search and replace" },
        },

        ["o"] = {
            name = "+open",
            ["1"] = { "<Cmd>1ToggleTerm direction=float<CR>", "Toggle term1" },
            ["2"] = { "<Cmd>2ToggleTerm direction=vertical<CR>", "Toggle term2" },
            ["m"] = { "<Cmd>MarkdownPreviewToggle<CR>", "Toggle markdown preview" },
            ["q"] = { "<Cmd>copen<CR>", "Open quick fix list" }
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
            ["b"] = { "<Cmd>Gitsigns blame_line<CR>", "Git blame_line" },
            ["d"] = { "<Cmd>Gitsigns diffthis<CR>", "Git diff" },
            ["h"] = { "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk" },
            ["i"] = { "<Cmd>GitShow<CR>", "Git show" },
            ["l"] = { "<Cmd>GitLog<CR>", "Git log" },
            ["v"] = { "<Cmd>Gitsigns select_hunk<CR>", "Git select hunk" },
            ["r"] = { "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk" },
            ["R"] = { "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer" },
            ["s"] = { "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk" },
            ["S"] = { "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer" },
            ["u"] = { "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk" },
            ["y"] = { function() require "gitlinker".get_buf_range_url("n") end, "Git copy link" },
            ["o"] = {
                name = "+open",
                ["s"] = { "<Cmd>Telescope git_stash<CR>", "Git stash" },
                ["c"] = { "<Cmd>Telescope git_commits<CR>", "Git commits" },
                ["b"] = { "<Cmd>Telescope git_branches<CR>", "Git branches" },
            }
        },

    }
}

local v_keymaps = {
    ["#"] = {
        function() cmd([[let @/="]] .. utils.get_visual_selection() .. [["]] .. [[ | set hls]]) end,
        "Search word without jumping"
    },

    ["p"] = { [["_dP]], "Replace without yanking" },

    ["c"] = { [["_c]], "Change without yanking" },
    ["C"] = { [["_C]], "Change without yanking" },

    ["il"] = { ":normal ^vg_<CR>", "Line textobject" },
    ["al"] = { ":normal 0v$h<CR>", "Line textobject" },
    ["<"]  = { "<gv", "Indent left" },
    [">"]  = { ">gv", "Indent right" },

    -- Fast shortcuts
    ["<C-s>"] = { function() t.live_grep({ default_text = utils.get_visual_selection() }) end, "Live grep" },
    ["<C-f>"] = { function() t.find_files({ default_text = utils.get_visual_selection() }) end, "Find files" },
    ["<C-1>"] = { ":ToggleTermSendVisualSelectionNoTW 1<CR>", "Send visual selection to term 1" },
    ["<C-2>"] = { ":ToggleTermSendVisualSelectionNoTW 2<CR>", "Send visual selection to term 2" },

    ["<leader>"] = {
        name = "+SPC",

        ["s"] = {
            name  = "+search",
            ["s"] = {
                function() t.grep_string({ default_text = utils.get_visual_selection() }) end,
                "Search string"
            },
            ["b"] = {
                function() t.current_buffer_fuzzy_find({ default_text = utils.get_visual_selection() }) end,
                "Search buffer"
            }
        },

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
    ["il"] = { ":normal vil<CR>", "Line textobject" },
    ["al"] = { ":normal val<CR>", "Line textobject" },
}

wk.register(n_keymaps, { mode = "n" })
wk.register(v_keymaps, { mode = "v" })
wk.register(i_keymaps, { mode = "i" })
wk.register(t_keymaps, { mode = "t" })
wk.register(c_keymaps, { mode = "c" })
wk.register(o_keymaps, { mode = "o" })
