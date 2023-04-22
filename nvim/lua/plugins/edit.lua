return {
    -- Surroundings
    {
        "echasnovski/mini.surround",
        keys = function()
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            return {
                { opts.mappings.add,            desc = "Add surrounding",        mode = { "n", "v" } },
                { opts.mappings.delete,         desc = "Delete surrounding" },
                { opts.mappings.replace,        desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `coverage lines`" },
            }
        end,
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
        event = "VeryLazy",
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
        keys = {
            { "<leader>s", function() require("spectre").open() end,             desc = "Search and replace" },
            { "<leader>S", function() require("spectre").open_file_search() end, desc = "Search and replace current file" },
        }
    },

    -- Auto pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        version = false,
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    }

}
