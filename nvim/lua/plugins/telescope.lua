local M = {}

function M.setup(use)
    -- Telescope extesions
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        requires = { "nvim-telescope/telescope.nvim" },
        config = function() require("telescope").load_extension("fzf") end
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
                defaults = {
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
                        find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
                    },
                    buffers = {
                        theme = "dropdown",
                        sorting_strategy = "ascending",
                        ignore_current_buffer = true,
                        sort_mru = true,
                        previewer = false,
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
                        previewer = false
                    }
                }
            })
        end,
        requires = { "nvim-lua/plenary.nvim" },
    })
end

return M