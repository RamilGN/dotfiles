-- Telescope
return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = require("config.keymaps").telescope,
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local telescope_config = require("telescope.config")

            local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")

            telescope.setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    mappings = {
                        i = {
                            ["<Esc>"] = actions.close,
                            ["<C-\\>"] = actions.close,
                            ["<C-j>"] = { "<C-^>", type = "command" }
                        },
                    },
                    dynamic_preview_title = true,
                    preview = {
                        treesitter = {
                            disable = { "eruby" } -- 100% memory WTF 0_0
                        }
                    }
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        mappings = {
                            i = {
                                ["<C-f>"] = function(prompt_bufnr)
                                    local selection = require("telescope.actions.state").get_selected_entry()
                                    local file = vim.fn.fnamemodify(selection.path, ":p")
                                    local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                                    require("telescope.actions").close(prompt_bufnr)
                                    vim.cmd([[silent tcd ]] .. dir)
                                    vim.cmd([[e ]] .. file)
                                end
                            }
                        },
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
                    },
                    live_grep = {
                        glob_pattern = { "!vendor" },
                    },
                    buffers = {
                        theme = "dropdown",
                        sorting_strategy = "ascending",
                        ignore_current_buffer = true,
                        sort_mru = true,
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer
                            }
                        }
                    },
                    git_branches = {
                        theme = "dropdown",
                        previewer = false,
                    },
                    lsp_workspace_symbols = {
                        symbol_width = 65
                    },
                    lsp_document_symbols = {
                        theme = "dropdown",
                    }
                },
                extensions = {
                    undo = {
                        use_delta = true,
                    }
                }
            })
        end,
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },
    {
        "debugloop/telescope-undo.nvim",
        config = function()
            require("telescope").load_extension("undo")
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end
    }
}
