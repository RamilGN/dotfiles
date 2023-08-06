return {
    -- Surroundings
    {
        "echasnovski/mini.surround",
        keys = require("config.keymaps").mini.surround,
        opts = {
            mappings = {
                add = "ys",
                delete = "ds",
                replace = "cs",
                update_n_lines = "gs",
            },
        },
        config = function(_, opts)
            require("mini.surround").setup(opts)
        end,
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
                replace = "DiffDelete"
            },
        }
    },

    -- Auto pairs
    {
        "echasnovski/mini.pairs",
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        config = function(_, opts) require("mini.pairs").setup(opts) end,
    },

    { "nmac427/guess-indent.nvim",                   config = function() require("guess-indent").setup {} end }
}
