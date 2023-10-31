return {
    -- Surroundings
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    -- Comments
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "echasnovski/mini.comment",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring({}) or vim.bo.commentstring
                end,
            },
        },
    },
    -- Search and replace
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        keys = require("config.keymaps").spectre,
        opts = {
            highlight = {
                ui = "String",
                search = "DiffAdd",
                replace = "DiffDelete",
            },
        },
    },
    -- Auto pairs
    {
        "echasnovski/mini.pairs",
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },
    -- Auto-indent
    {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup({})
        end,
    },
}
