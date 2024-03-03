local Util = function()
    return require("util")
end

return {
    core = function()
        local map = vim.keymap.set
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
        map("v", "#", function()
            local text = Util().get_visual_selection_for_telescope()
            vim.fn.setreg("/", text)
            vim.cmd("set hls")
        end, { desc = "Search word without jumping" })
        -- Turn off highlight.
        map("n", "//", ":nohlsearch<CR>", { desc = "Turn off highlight" })
        -- Better up/down.
        map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Up with line wrap", expr = true, silent = true })
        map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Down with line wrap", expr = true, silent = true })
        map({ "i", "c" }, "<C-h>", "<Left>", { desc = "Go to left window" })
        map({ "i", "c" }, "<C-l>", "<Right>", { desc = "Go to right window" })
        map("n", "<C-h>", "<C-w><Left>", { desc = "Go to left window" })
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
        -- Normal mode in terminal.
        map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Normal mode" })
        map("t", "<C-w>c", "<C-\\><C-n><C-w>c", { desc = "Close terminal" })
        map("t", "<C-u>", "<C-\\><C-n><C-u>", { desc = "Scroll up" })
        map("t", "<C-d>", "<C-\\><C-n><C-u>", { desc = "Scroll down" })
        map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Left window" })
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
        map({ "n", "v" }, "<leader>gll", ":Gitx log<CR>", { desc = "Git log" })
        map("n", "<leader>glg", "<Cmd>Gitx log_global<CR>", { desc = "Git log global" })
        map("n", "<leader>gii", "<Cmd>Gitx show<CR>", { desc = "Git show" })
        map("n", "<leader>gip", "<Cmd>Gitx showprev<CR>", { desc = "Git show prev" })
        -- Set options and misc.
        map("n", "yos", "<Cmd>setlocal invspell<CR>", { desc = "Set spelling" })
        map("n", "yoc", "<Cmd>SetColorColumn<CR>", { desc = "Set vert limit bar" })
        map("n", "yol", "<Cmd>set invrelativenumber<CR>", { desc = "Toggle relative number" })
        map("n", "yof", function()
            Util().copy_rel_path_line_to_buffer()
        end, { desc = "Yank file path with line" })
        -- Prev action.
        map("n", "[b", "<C-^>", { desc = "Last buffer" })
        map("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Prev tab" })
        map("n", "[q", "<Cmd>cprev<CR>", { desc = "Prev item in qf" })
        -- Next action.
        map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })
        map("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next tab" })
        -- Quickifx list.
        map("n", "<leader>q", "<Cmd>copen<CR>", { desc = "Open quick fix list" })
        -- Run commands.
        map({ "n", "v" }, "<leader>ru", ":Run<CR>", { desc = "Run current file" })
        map("n", "<leader>re", function()
            vim.cmd(vim.g.last_command)
        end, { desc = "Last command" })
        map("n", "<leader>rv", "<Cmd>@:<CR>", { desc = "Last command no expand" })
        map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
        -- Open smth.
        map("n", "<leader>ot", "<Cmd>$tabnew %<CR>", { desc = "Open tab for current buffer" })
        -- Open url with gx.
        map("n", "gx", function()
            local word = vim.fn.expand("<cWORD>")
            local url_pattern = "https?://[a-zA-Z%d_/%%%-%.~@\\+#=?&:]+"
            local url = word:match(url_pattern)

            if url then
                return Util().sysopen(url)
            end

            if not url then
                url_pattern = "([a-zA-Z%d_/%-%.~@\\+#]+%.[a-zA-Z%d_/%%%-%.~@\\+#=?&:]+)"
                url = word:match(url_pattern)

                if url then
                    url = "https://" .. url
                    return Util().sysopen(url)
                end
            end
        end, { desc = "Open file with system app" })
        -- Spacing.
        map("n", "]<leader>", "<Cmd>norm i <CR>l", { desc = "Next buffer" })
        map("n", "[<leader>", "<Cmd>norm <CR> h", { desc = "Next tab" })
        -- Mind.
        map("n", "<leader>mt", "<Cmd>e ~/mind/todo/current.md<CR>", { desc = "Open todo in mind" })
        map("n", "<leader>mf", "<Cmd>Telescope find_files cwd=~/mind<CR>", { desc = "Find files in mind" })
        map("n", "<leader>ms", "<Cmd>Telescope live_grep cwd=~/mind<CR>", { desc = "Live grep in mind" })
        -- Language specific
        -- go
        map("n", "<leader>ng", function()
            vim.cmd("e ~/workspace/scratch/main.go")
        end, { desc = "Scratch" })
    end,
    luasnip = function()
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
            {
                "<C-f>",
                function()
                    require("luasnip").jump(1)
                end,
                mode = { "s" },
            },
            {
                "<C-d>",
                function()
                    require("luasnip").jump(-1)
                end,
                mode = { "i", "s" },
            },
            {
                "<BS>",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Del>", true, true, true), "x")
                    require("luasnip").jump(1)
                end,
                mode = { "s" },
            },
        }
    end,
    cmp = function()
        local cmp = require("cmp")
        return {
            ["<C-u>"] = cmp.mapping.scroll_docs(-2),
            ["<C-d>"] = cmp.mapping.scroll_docs(2),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            ["<S-CR>"] = cmp.mapping.confirm({ select = true }),
        }
    end,
    mason = function()
        return {
            { "<leader>pm", "<Cmd>Mason<CR>", desc = "Mason" },
        }
    end,
    spectre = function()
        return {
            {
                "<leader>s",
                function()
                    require("spectre").toggle()
                end,
                desc = "Search and replace",
            },
            {
                "<leader>S",
                function()
                    require("spectre").open_file_search({})
                end,
                desc = "Search and replace current file",
            },
        }
    end,
    markdown_preview = function()
        return {
            { "<leader>om", "<Cmd>MarkdownPreviewToggle<CR>", desc = "Toggle markdown preview" },
        }
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
            local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
            map("n", "]g", function()
                next_hunk_repeat({ preview = true })
            end, "Next Hunk")
            map("n", "[g", function()
                prev_hunk_repeat({ preview = true })
            end, "Prev Hunk")
            map("n", "H", "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk")
            map("n", "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk")
            map("n", "<leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer")
            map("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
            map("n", "<leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer")
            map("n", "<leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk")
            map("n", "<leader>gd", "<Cmd>Gitsigns diffthis<CR>", "Diff")
        end,
        fugitive = function()
            return {
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
                    "<Cmd>G ++curwin log -n 100<CR>",
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
                    Util().input("Branch name", function(input)
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
                    "<Cmd>V gcm<CR>",
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
                    function()
                        vim.cmd("GBrowse!")
                        local link = vim.fn.getreg("+")
                        Util.sysopen(link)
                    end,
                    desc = "Git open link",
                    mode = { "n", "v" },
                },
                {
                    "<leader>gyy",
                    ":GBrowse!<CR>",
                    desc = "Git copy link",
                    mode = { "n", "v" },
                },
            }
        end,
    },
    oil = {
        keys = function()
            return {
                {
                    "<C-Space>",
                    function()
                        local open = require("oil").open
                        if vim.bo.filetype == "fugitive" then
                            open(".")
                        else
                            open()
                        end
                    end,
                    desc = "Open file explorer",
                    mode = { "t", "n" },
                },
            }
        end,
        explorer = function()
            return {
                ["~"] = false,
                ["<C-l>"] = false,
                ["<C-s>"] = false,
                ["<C-h>"] = false,
                ["g~"] = {
                    desc = "Go to home",
                    callback = function()
                        vim.cmd("edit $HOME")
                    end,
                },
                ["<C-Space>"] = "actions.close",
                ["gr"] = "actions.refresh",
                ["gv"] = "actions.select_vsplit",
                ["gc"] = "actions.change_sort",
                ["gs"] = "actions.select_split",
                ["g."] = "actions.open_cmdline",
                ["gh"] = "actions.toggle_hidden",
                ["gx"] = "actions.open_external",
                ["gd"] = {
                    desc = "Toggle detail view",
                    callback = function()
                        local oil = require("oil")
                        local config = require("oil.config")
                        if #config.columns == 1 then
                            oil.set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            oil.set_columns({ "icon" })
                        end
                    end,
                },
            }
        end,
    },
    neogen = function()
        return {
            { "<leader>ln", ":Neogen<CR>", desc = "Annotate" },
        }
    end,
    toggleterm = function()
        return {
            {
                "<C-\\>",
                "<Cmd>ToggleTerm<CR>",
                desc = "Toggle term",
            },
            {
                "<leader>o2",
                "<Cmd>22ToggleTerm direction=vertical<CR>",
                desc = "Open interactive terminal",
            },
            {
                "<leader>rt",
                function()
                    vim.cmd("22TermExec direction=vertical cmd='" .. vim.g.last_cmd .. "'")
                end,
                desc = "Last command in term",
            },
            {
                "<C-2>",
                "<Cmd>SendCurrentLineToTerm<CR>",
                desc = "Send line to term",
            },
            {
                "<C-2>",
                ":SendVisualSelectionToTerm<CR>",
                desc = "Send visual selection to term",
                mode = "v",
            },
            {
                "<C-3>",
                "<Cmd>SendSpaceToTerm<CR>",
                desc = "Send space to term",
            },
            {
                "<C-4>",
                "<Cmd>SendQToTerm<CR>",
                desc = "Send q to term",
            },
            {
                "<C-5>",
                "<Cmd>SendClearToTerm<CR>",
                desc = "Send q to term",
            },
        }
    end,
    telescope = function()
        local Util = function()
            return require("util")
        end
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
                    t().current_buffer_fuzzy_find({ default_text = Util().get_visual_selection_for_telescope() })
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
                    t().find_files({ default_text = Util().get_cur_buf_dir_rel_path() })
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
                    t().find_files({ default_text = Util().get_visual_selection_for_telescope() })
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
                    t().live_grep({ default_text = Util().get_visual_selection_for_telescope() })
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
                    t().grep_string({ default_text = Util().get_visual_selection() })
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
    lsp = function(buffer, _)
        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "<C-q>", "<Cmd>Telescope lsp_document_symbols<CR>", "LSP document symbols")
        map("n", "<leader>li", "<Cmd>LspInfo<CR>", "Lsp info")
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>lw", "<Cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols")
        map("n", "<leader>lx", "<Cmd>LspRestart<CR>", "Lsp restart")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gI", "<Cmd>Telescope lsp_implementations<CR>", "Go to Implementation")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
        map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", "Go to definition")
        map("n", "gr", "<Cmd>Telescope lsp_references<CR>", "Show references")
        map("n", "gy", "<Cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition")
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code actions")
    end,
    formatting = function()
        return {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = { "n", "v" },
                desc = "Format buffer",
            },
            {
                "<leader>lF",
                function()
                    require("conform").format({ async = true, formatters = { "injected" } })
                end,
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
        }
    end,
    sibling = function()
        return {
            {
                "[a",
                function()
                    require("sibling-swap").swap_with_left()
                end,
                desc = "Swap node with left",
            },
            {
                "]a",
                function()
                    require("sibling-swap").swap_with_right()
                end,
                desc = "Swap node with right",
            },
        }
    end,
    gpt = function()
        return {
            {
                "<leader>cc",
                ":GptChatToggle new<CR>",
                desc = "GPT chat toggle",
                mode = { "n", "v" },
            },
            {
                "<leader>ca",
                ":GptChatNew new<CR>",
                desc = "GPT chat new ",
                mode = { "n", "v" },
            },
            {
                "<leader>ce",
                ":GptEnew<CR>",
                desc = "GPT in buffer",
                mode = { "n", "v" },
            },
            {
                "<leader>ci",
                ":GptImplement<CR>",
                desc = "GPT implement in buffer",
                mode = { "n", "v" },
            },
            {
                "<leader>cr",
                ":GptRewrite<CR>",
                desc = "GPT rewrite in buffer",
                mode = { "n", "v" },
            },
        }
    end,
}
