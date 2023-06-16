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
            hooks = {
                pre = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end,
            },
        },
        config = function(_, opts) require("mini.comment").setup(opts) end,
    },

    -- Serach and replace
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        keys = require("config.keymaps").spectre
    },

    -- Buffer remove
    {
        "echasnovski/mini.bufremove",
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
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
