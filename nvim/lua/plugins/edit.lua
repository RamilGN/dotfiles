local M = {}

function M.setup(use)
    -- Autopairs
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    })

    -- Surroundings
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end
    })

    -- Easy tables
    use({
        "dhruvasagar/vim-table-mode",
        config = function()
            vim.g.table_mode_corner = "|"
            vim.g.table_mode_map_prefix = "<Leader><Bar>"
            vim.g.table_mode_update_time = 250
            vim.g.table_mode_auto_align = 1
        end
    })

    -- Comments
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    })

    -- Serach and replace
    use({
        "nvim-pack/nvim-spectre",
        config = function()
            require("spectre").setup()

            vim.keymap.set("n", "<leader>S", function()
                require("spectre").open()
            end)
            vim.keymap.set("n", "<leader>s", function()
                require("spectre").open_file_search()
            end)
        end
    })
end

return M
