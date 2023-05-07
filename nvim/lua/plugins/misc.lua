return {
    -- Popup with suggestions to complete a key binding
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>ga"] = { name = "+add" },
                ["<leader>gc"] = { name = "+commit" },
                ["<leader>gi"] = { name = "+info/show" },
                ["<leader>gl"] = { name = "+log" },
                ["<leader>go"] = { name = "+open" },
                ["<leader>gp"] = { name = "+push/pull" },
                ["<leader>p"] = { name = "+plugins/packages" },
                ["<leader>ll"] = { name = "+server" },
                ["<leader>r"] = { name = "+run" },
                ["<leader>m"] = { name = "+misc" },
                ["<leader>o"] = { name = "+open/toggle" },
                ["<leader>h"] = { name = "+help" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        keys = require("config.keymaps").neotree,
        cmd = "Neotree",
        config = function()
            require("neo-tree").setup({
                log_level = "warn",
                enable_diagnostics = true,
                event_handlers = {
                    {
                        event = "neo_tree_buffer_enter",
                        handler = function()
                            vim.opt_local.signcolumn = "no"
                            vim.opt_local.cursorlineopt = "number,line"
                            vim.opt_local.number = true
                            vim.opt_local.relativenumber = true
                        end
                    },
                },
                filesystem = {
                    hijack_netrw_behavior = "open_default",
                    use_libuv_file_watcher = true,
                    commands = {
                        system_open = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.api.nvim_command([[silent !xdg-open ]] .. path)
                        end,
                        run_command = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.api.nvim_input(": " .. path .. "<Home>")
                        end,
                        copy_path = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path)
                        end,
                    },
                    window = {
                        position = "current",
                        mappings = {
                            ["f"] = "fuzzy_finder",
                            ["F"] = "filter_on_submit",
                            ["o"] = "system_open",
                            ["i"] = "run_command",
                            ["gy"] = "copy_path",
                            ["/"] = "noop",
                            ["<space>"] = "noop",
                            ["l"] = "noop",
                            ["#"] = "noop",
                        }
                    }
                },
                default_component_configs = {
                    git_status = {
                        symbols = {
                            -- Change type
                            added     = "",
                            modified  = "",
                            deleted   = "✖",
                            renamed   = "",
                            -- Status type
                            untracked = "",
                            ignored   = "",
                            unstaged  = "",
                            staged    = "",
                            conflict  = "",
                        }
                    },
                }
            })
        end
    },

    -- Terminal management
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec" },
        config = function()
            local toggleterm = require("toggleterm")

            toggleterm.setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 20
                    elseif term.direction == "vertical" then
                        return math.floor(vim.o.columns * 0.5)
                    end
                end,
                open_mapping = [[<C-\>]],
                insert_mappings = true,
                persist_size = false,
                persist_mode = false,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
                auto_scroll = true
            })

            vim.api.nvim_create_user_command("ToggleTermSendCurrentLineNoTW",
                function(opts)
                    toggleterm = require("toggleterm")

                    toggleterm.send_lines_to_terminal("single_line", false, opts)
                end,
                { nargs = "?" }
            )

            vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionNoTW",
                function(opts)
                    toggleterm = require("toggleterm")

                    toggleterm.send_lines_to_terminal("visual_selection", false, opts)
                end,
                { range = true, nargs = "?" }
            )
        end,
        keys = require("config.keymaps").toggleterm()
    },

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        cmd = "MarkdownPreviewToggle",
        event = { "BufReadPost", "BufNewFile" },
        keys = require("config.keymaps").markdown_preview,
    },

    -- Undo tree
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_DiffAutoOpen = 0
            vim.g.undotree_SplitWidth = math.floor(vim.o.columns * 0.2)
        end,
        keys = require("config.keymaps").undotree
    }
}
