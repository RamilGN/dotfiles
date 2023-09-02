return {
    core             = function()
        local f = require("functions")
        local map = vim.keymap.set
        -- Package manager.
        map("n", "<leader>pp", "<Cmd>Lazy home<CR>", { desc = "Plugins" })
        -- Search without jumping.
        map("n", "#", ":let @/='\\<'.expand('<cword>').'\\>' | set hls <CR>", { desc = "Search word without jumping", silent = true })
        map("v", "#", function() vim.cmd([[let @/="]] .. f.vim.get_visual_selection() .. [["]] .. [[ | set hls]]) end, { desc = "Search word without jumping" })
        -- Turn off highlight.
        map("n", "//", ":nohlsearch<CR>", { desc = "Turn off highlight" })
        -- Better up/down.
        map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Up with line wrap", expr = true, silent = true })
        map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Down with line wrap", expr = true, silent = true })
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
        map("n", "gf", "gF")
        map("n", "gF", "gf")
        -- New lines.
        map("n", "<CR>", "m`o<Esc>``", { desc = "Insert new line below cursor" })
        map("n", "<S-CR>", "m`O<Esc>``", { desc = "Insert new line under cursor" })
        -- Close buffer.
        map("n", "<C-w>b", ":bd! %<CR>", { desc = "Close current buffer" })
        -- Without yank.
        map("v", "p", [["_dP]], { desc = "Replace without yanking" })
        map({ "n", "v" }, "c", [["_c]], { desc = "Change without yanking" })
        map({ "n", "v" }, "C", [["_C]], { desc = "Change without yanking" })
        -- Normal mode in terminal.
        map("t", "<C-[>", "<C-\\><C-n>", { desc = "Normal mode" })
        -- Windows.
        map("n", "<C-k>", "<C-w><Up>", { desc = "Go to upper window" })
        map("n", "<C-j>", "<C-w><down>", { desc = "Go to bottom window" })
        map({ "i", "c", "t" }, "<C-j>", "<C-^>", { desc = "Switch layout" })
        map("n", "<C-l>", "<C-w><right>", { desc = "Go to right window" })
        map("n", "<C-h>", "<C-w><Left>", { desc = "Go to left window" })
        map("n", "<C-Up>", "<Cmd>resize -2<CR>", { desc = "Resize horiz-" })
        map("n", "<C-Down>", "<Cmd>resize +2<CR>", { desc = "Resize horiz+" })
        map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Resize vert-" })
        map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Resize vert+" })
        -- Git.
        map({ "n", "v" }, "<leader>gll", ":GitLog<CR>", { desc = "Git log" })
        map("n", "<leader>glg", "<Cmd>GitLogG<CR>", { desc = "Git log global" })
        map("n", "<leader>gii", "<Cmd>GitShow<CR>", { desc = "Git show" })
        map("n", "<leader>gip", "<Cmd>GitShowPrev<CR>", { desc = "Git show prev" })
        -- Set options and misc.
        map("n", "yos", "<Cmd>setlocal invspell<CR>", { desc = "Set spelling" })
        map("n", "yoc", "<Cmd>SetColorColumn<CR>", { desc = "Set vert limit bar" })
        map("n", "yof", f.vim.copy_rel_path_line_to_buffer, { desc = "Yank file path with line" })
        -- Prev action.
        map("n", "[b", "<C-^>", { desc = "Last buffer" })
        map("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Prev tab" })
        map("n", "[q", "<Cmd>cprev<CR>", { desc = "Prev item in qf" })
        -- Next action.
        map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })
        map("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next tab" })
        -- Line textobject.
        map("v", "il", ":normal ^vg_<CR>", { desc = "in Line" })
        map("o", "il", ":normal vil<CR>", { desc = "in line" })
        map("v", "al", ":normal 0v$h<CR>", { desc = "around line" })
        map("o", "al", ":normal val<CR>", { desc = "around line" })
        -- Quickifx list.
        map("n", "<leader>qo", "<Cmd>copen<CR>", { desc = "Open quick fix list" })
        -- Run commands.
        map({ "n", "v" }, "<leader>ru", ":Run<CR>", { desc = "Run current file" })
        map("n", "<leader>re", function() vim.cmd(vim.g.last_command) end, { desc = "Last command" })
        map("n", "<leader>rv", "<Cmd>@:<CR>", { desc = "Last command no expand" })
        map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
        -- Open smth.
        map("n", "<leader>ot", "<Cmd>$tabnew %<CR>", { desc = "Open tab for current buffer" })
        map("n", "gx", "<Cmd>silent !xdg-open <cWORD><CR>", { desc = "Open file with system app" })
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
            { "<C-f>", function() require("luasnip").jump(1) end,  mode = { "s" } },
            { "<C-d>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } }
        }
    end,
    cmp              = function()
        local cmp = require("cmp")
        return {
            ["<C-u>"] = cmp.mapping.scroll_docs(-2),
            ["<C-d>"] = cmp.mapping.scroll_docs(2),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            ["<S-CR>"] = cmp.mapping.confirm({ select = true }),
        }
    end,
    mason            = function()
        return {
            { "<leader>pm", "<Cmd>Mason<CR>", desc = "Mason" }
        }
    end,
    spectre          = function()
        return {
            { "<leader>s", function() require("spectre").toggle() end,             desc = "Search and replace" },
            { "<leader>S", function() require("spectre").open_file_search({}) end, desc = "Search and replace current file" },
        }
    end,
    markdown_preview = function()
        return {
            { "<leader>om", "<Cmd>MarkdownPreviewToggle<CR>", desc = "Toggle markdown preview" },
        }
    end,
    git              = {
        signs = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end
            local gs = package.loaded.gitsigns
            -- Blame.
            map("n", "<leader>gb", "<Cmd>Gitsigns blame_line<CR>", "Git blame_line")
            -- Diff.
            map("n", "<leader>gd", "<Cmd>Gitsigns diffthis split=botright<CR>", "Git diff")
            -- Hunks.
            local tsrm = require "nvim-treesitter.textobjects.repeatable_move"
            local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
            map("n", "]g", function() next_hunk_repeat({ preview = true }) end, "Next Hunk")
            map("n", "[g", function() prev_hunk_repeat({ preview = true }) end, "Prev Hunk")
            map("n", "H", "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk")
            map("n", "<leader>ghs", "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk")
            map("n", "<leader>ghv", "<Cmd>Gitsigns select_hunk<CR>", "Git select hunk")
            map("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
            map("n", "<leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk")
            -- Buffers.
            map("n", "<leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer")
            map("n", "<leader>gsb", "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer")
        end,
        fugitive = function()
            local f = require("functions")
            return {
                -- Git menu.
                { "<leader>gg",   "<Cmd>G ++curwin<CR>",                                                              desc = "Git" },
                -- Git add.
                { "<leader>gaa",  "<Cmd>G ++curwin add -v --patch<CR>",                                               desc = "Git add patch" },
                -- Git log.
                { "<leader>glo",  "<Cmd>G ++curwin log -n 1000<CR>",                                                  desc = "Git log 1000" },
                -- Git stash.
                { "<leader>gstl", "<Cmd>V gstl-np<CR>",                                                               desc = "Git stash list" },
                { "<leader>gsti", "<Cmd>V gsti<CR>",                                                                  desc = "Git stash apply" },
                -- Git commit/checkout.
                { "<leader>gca",  "<Cmd>G ++curwin commit -v --amend<CR>",                                            desc = "Git commit amend" },
                { "<leader>gcb",  f.vim.input("Branch name", function(input) vim.cmd("G checkout -b " .. input) end), desc = "Git checkout new branch" },
                { "<leader>gcc",  "<Cmd>G ++curwin commit -v<CR>",                                                    desc = "Git commit" },
                { "<leader>gcm",  "<Cmd>V gcm<CR>",                                                                   desc = "Git checkout master" },
                { "<leader>gco",  "<Cmd>V gco<CR>",                                                                   desc = "Git checkout" },
                { "<leader>gcn",  "<Cmd>G ++curwin commit -v --amend --no-edit<CR>",                                  desc = "Git commit amend no-edit" },
                -- Git pull/push.
                { "<leader>gpf",  "<Cmd>G push -v --force-with-lease<CR>",                                            desc = "Force push" },
                { "<leader>gpl",  "<Cmd>G pull -v<CR>",                                                               desc = "Git pull" },
                { "<leader>gpp",  "<Cmd>G push -v<CR>",                                                               desc = "Push" },
                { "<leader>gyo",  ":GBrowse<CR>",                                                                     desc = "Git open link",           mode = { "n", "v" } },
                { "<leader>gyy",  ":GBrowse!<CR>",                                                                    desc = "Git copy link",           mode = { "n", "v" } },
            }
        end,
    },
    oil              = function()
        return {
            { "<C-Space>", "<Cmd>Oil<CR>", desc = "Open file explorer" }
        }
    end,
    neogen           = function()
        return {
            { "<leader>ln", ":Neogen<CR>", desc = "Annotate" }
        }
    end,
    toggleterm       = function()
        return {
            { "<C-\\>",     "<Cmd>ToggleTerm<CR>",                                                                 desc = "Toggle term" },
            { "<leader>o1", "<Cmd>1ToggleTerm direction=float<CR>",                                                desc = "Toggle term1" },
            { "<leader>o2", "<Cmd>2ToggleTerm direction=vertical<CR>",                                             desc = "Toggle term2" },
            { "<leader>o3", "<Cmd>3ToggleTerm direction=vertical<CR>",                                             desc = "Toggle term3" },
            { "<leader>rt", function() vim.cmd("2TermExec direction=vertical cmd='" .. vim.g.last_cmd .. "'") end, desc = "Last command in term" },
            { "<C-1>",      "<Cmd>ToggleTermSendCurrentLineNoTW 1<CR>",                                            desc = "Send line to term 1" },
            { "<C-1>",      ":ToggleTermSendVisualSelectionNoTW 1<CR>",                                            desc = "Send visual selection to term 1", mode = "v" },
            { "<C-2>",      "<Cmd>ToggleTermSendCurrentLineNoTW 2<CR>",                                            desc = "Send line to term 2" },
            { "<C-2>",      ":ToggleTermSendVisualSelectionNoTW 2<CR>",                                            desc = "Send visual selection to term 2", mode = "v" },
            { "<C-3>",      "<Cmd>ToggleTermSendCurrentLineNoTW 3<CR>",                                            desc = "Send line to term 3" },
            { "<C-3>",      ":ToggleTermSendVisualSelectionNoTW 3<CR>",                                            desc = "Send visual selection to term 3", mode = "v" },
        }
    end,
    telescope        = function()
        local f = require("functions")
        local t = require("telescope.builtin")

        return {
            -- Search.
            { "<C-/>",       "<Cmd>Telescope current_buffer_fuzzy_find<CR>",                                              desc = "Search buffer" },
            { "<C-/>",       function() t.current_buffer_fuzzy_find({ default_text = f.vim.get_visual_selection() }) end, desc = "Search buffer",          mode = "v" },
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
            { "<leader>gob", function() t.git_branches({ show_remote_tracking_branches = false }) end,                    desc = "Git branches" },
            { "<leader>goB", function() t.git_branches() end,                                                             desc = "Git branches all" },
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
            { "<leader>o:",  "<Cmd>Telescope command_history<CR>",                                                        desc = "Command history" },
            { "<leader>o/",  "<Cmd>Telescope search_history<CR>",                                                         desc = "Search history" },
            { "<leader>or",  function() t.oldfiles({ only_cwd = true }) end,                                              desc = "Open recent files" },
            { "<leader>od",  "<Cmd>Telescope diagnostics<CR>",                                                            desc = "Diagnostics" },
            { "<leader>oy",  "<Cmd>YAMLTelescope<CR>",                                                                    desc = "Diagnostics" },
            { "<leader>os",  f.vim.input("Grep string", function(input) t.grep_string({ search = input }) end),           desc = "Grep string" },
            { "<leader>os",  function() t.grep_string({ default_text = f.vim.get_visual_selection() }) end,               desc = "Grep string",            mode = "v" },
            { "<leader>ou",  "<Cmd>Telescope undo<CR>",                                                                   desc = "Undo history" },
        }
    end,
    lsp              = function(buffer, _)
        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
        map("n", "<C-q>", "<Cmd>Telescope lsp_document_symbols<CR>", "LSP document symbols")
        map("n", "<leader>li", "<Cmd>LspInfo<CR>", "Lsp info")
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>lw", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols")
        map("n", "<leader>lx", "<Cmd>LspRestart<CR>", "Lsp restart")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gI", "<Cmd>Telescope lsp_implementations<CR>", "Go to Implementation")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
        map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", "Go to definition")
        map("n", "gr", "<Cmd>Telescope lsp_references<CR>", "Show references")
        map("n", "gy", "<Cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition")
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code actions")
        map({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
    end
}
