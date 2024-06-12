return {
    -- Surroundings
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    -- Auto pairs
    {
        "echasnovski/mini.pairs",
        event = { "BufReadPre", "BufNewFile" },
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },
    -- Better text objects.
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")

            return {
                n_lines = 500,
                mappings = {
                    around_last = "",
                    inside_last = "",
                },
                custom_textobjects = {
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    l = function(operator)
                        local from = nil
                        local to = nil
                        local cur = vim.fn.getcurpos(0)
                        local cur_line_num = cur[2]
                        local end_of_cur_line = vim.fn.getline(cur_line_num):len()

                        if operator == "a" then
                            from = { line = cur_line_num, col = 1 }
                            to = { line = cur_line_num, col = end_of_cur_line }
                        end

                        if operator == "i" then
                            local cur_line = vim.api.nvim_get_current_line()
                            local start_of_line = cur_line:find("%S")

                            from = { line = cur_line_num, col = start_of_line }
                            to = { line = cur_line_num, col = end_of_cur_line }
                        end

                        return { from = from, to = to }
                    end,
                },
                silent = true,
            }
        end,
    },
    -- Auto-indent
    {
        "tpope/vim-sleuth",
        event = { "BufReadPre", "BufNewFile" },
    },
    -- Comments.
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
    },
}
