local M = {}

function M.setup(use)
    -- Autopairs
    use({
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    })

    -- Surroundings
    use({
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup() end
    })

    -- Comments
    use({
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    })

    -- Serach and replace
    use({
        "nvim-pack/nvim-spectre",
        config = function() require("spectre").setup() end
    })
end

return M
