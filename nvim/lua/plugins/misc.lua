return {
    -- Popup with suggestions to complete a key binding
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
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
                            h = function(state)
                                local node = state.tree:get_node()
                                if (node.type == "directory" or node:has_children()) and node:is_expanded() then
                                    state.commands.toggle_node(state)
                                else
                                    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                                end
                            end,
                            l = function(state)
                                local node = state.tree:get_node()
                                if node.type == "directory" or node:has_children() then
                                    if not node:is_expanded() then
                                        state.commands.toggle_node(state)
                                    else
                                        require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                                    end
                                end
                            end,
                        },
                        ["h"] = function(state)
                            local node = state.tree:get_node()
                            if node.type == "directory" and node:is_expanded() then
                                require "neo-tree.sources.filesystem".toggle_directory(state, node)
                            else
                                require "neo-tree.ui.renderer".focus_node(state, node:get_parent_id())
                            end
                        end,
                        ["l"] = function(state)
                            local node = state.tree:get_node()
                            if node.type == "directory" then
                                if not node:is_expanded() then
                                    require "neo-tree.sources.filesystem".toggle_directory(state, node)
                                elseif node:has_children() then
                                    require "neo-tree.ui.renderer".focus_node(state, node:get_child_ids()[1])
                                end
                            end
                        end,
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
        config = function()
            local toggleterm = require("toggleterm")

            toggleterm.setup {
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
                auto_scroll = true
            }
        end
    },

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install"
    },

    -- Undo tree
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_DiffAutoOpen = 0
            vim.g.undotree_SplitWidth = math.floor(vim.o.columns * 0.2)
        end
    }
}
