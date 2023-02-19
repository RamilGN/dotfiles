return {
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    },

    -- Surroundings
    {
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup() end
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },

    -- Serach and replace
    {
        "nvim-pack/nvim-spectre",
        config = function() require("spectre").setup() end
    }
}
