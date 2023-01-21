local M = {}

function M.setup(use)
    -- Popup with suggestions to complete a key binding
    use({
        "folke/which-key.nvim",
        config = {
            function()
                require("which-key").setup()
            end
        }
    })

    -- File explorer
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                log_level = "warn",
                popup_border_style = "rounded",
                filesystem = {
                    hijack_netrw_behavior = "open_default",
                    use_libuv_file_watcher = true,
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
                        }
                    },
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
                },
                event_handlers = {
                    { event = "neo_tree_buffer_enter",
                        handler = function()
                            vim.opt_local.signcolumn = "no"
                            vim.opt_local.cursorlineopt = "number,line"
                            vim.opt_local.number = true
                            vim.opt_local.relativenumber = true
                        end
                    },
                }
            })
        end
    }

    -- Terminal management
    use(
        {
            "akinsho/toggleterm.nvim", tag = "v2.*",
            config = function()
                local toggleterm = require("toggleterm")

                toggleterm.setup {
                    size = function(term)
                        if term.direction == "horizontal" then
                            return 20
                        elseif term.direction == "vertical" then
                            return math.floor(vim.o.columns * 0.4)
                        end
                    end,
                    open_mapping = [[<C-\>]],
                    insert_mappings = true,
                    persist_size = false,
                    persist_mode = false,
                    direction = "float",
                }
            end
        })

    -- Markdown
    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    })
end

return M
