local M = {}

function M.setup(use)
    -- Telescope
    use(
        {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
                requires = { "nvim-telescope/telescope.nvim" },
                config = function() require("telescope").load_extension("fzf") end
            },
            {
                "nvim-telescope/telescope.nvim",
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
                                    disable = { "eruby" }
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
                                }
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
                            lsp_workspace_symbols = {
                                symbol_width = 65
                            },
                            lsp_document_symbols = {
                                theme = "dropdown",
                            }
                        }
                    })
                end,
                requires = { "nvim-lua/plenary.nvim" },
            }
        }
    )
end

return M
