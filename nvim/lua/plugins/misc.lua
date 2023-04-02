return {
    -- Popup with suggestions to complete a key binding
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        tag = "nightly",
        config = function()
            require("nvim-tree").setup({
                view = {
                    number = true,
                    relativenumber = true,
                    signcolumn = "yes",
                    mappings = {
                        list = {
                            { key = "<CR>",  action = "edit_in_place" },
                            { key = "]d",    action = "next_diag_item" },
                            { key = "[d",    action = "prev_diag_item" },
                            { key = "]g",    action = "next_git_item" },
                            { key = "[g",    action = "prev_git_item" },

                            { key = "<C-e>", action = "" },
                            { key = "[c",    action = "" },
                            { key = "]c",    action = "" },
                            { key = "]e",    action = "" },
                            { key = "[e",    action = "" },
                        }
                    }
                },
                actions = {
                    open_file = {
                        quit_on_open = true
                    }
                },
                live_filter = {
                    prefix = "> "
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
    },

    { "github/copilot.vim" }
}
