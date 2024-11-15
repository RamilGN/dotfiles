return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "nvim-treesitter/nvim-treesitter-context", opts = { mode = "cursor" } },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "diff",
                    "gitcommit",
                    "go",
                    "gomod",
                    "gosum",
                    "gowork",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
                    "ruby",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "vue",
                    "yaml",
                },
                highlight = {
                    enable = true,
                    disable = function(_, bufnr)
                        return require("myplugins.util.buf").get_buf_byte_size(bufnr) > vim.g.max_byte_size
                    end,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ar"] = "@block.outer",
                            ["ir"] = "@block.inner",
                        },
                    },
                    move = {
                        set_jumps = true,
                        enable = true,
                        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                    },
                    lsp_interop = {
                        enable = true,
                        peek_definition_code = {
                            ["L"] = "@function.outer",
                            ["M"] = "@class.outer",
                        },
                    },
                },
                endwise = {
                    enable = true,
                },
                autotag = {
                    enable = true,
                },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25,
                    persist_queries = false,
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
            })

            local f = require("myplugins.util.init")
            local tsrm = require("nvim-treesitter.textobjects.repeatable_move")

            local go_to_context, _ = tsrm.make_repeatable_move_pair(function()
                require("treesitter-context").go_to_context()
            end, function() end)
            vim.keymap.set("n", "[z", go_to_context, { desc = "Go to context" })

            vim.keymap.set({ "n", "x", "o" }, ";", tsrm.repeat_last_move)
            vim.keymap.set({ "n", "x", "o" }, ",", tsrm.repeat_last_move_opposite)
            vim.keymap.set({ "n", "x", "o" }, "f", tsrm.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", tsrm.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", tsrm.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", tsrm.builtin_T_expr, { expr = true })

            local next_spell_repeat, prev_spell_repeat = tsrm.make_repeatable_move_pair(function()
                f.keys("]s")
            end, function()
                f.keys("[s")
            end)
            vim.keymap.set("n", "]s", next_spell_repeat, { desc = "Next spell error" })
            vim.keymap.set("n", "[s", prev_spell_repeat, { desc = "Prev spell error" })

            local next_diag_repeat, prev_diag_repeat = tsrm.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]d", next_diag_repeat, { desc = "Next diag error" })
            vim.keymap.set("n", "[d", prev_diag_repeat, { desc = "Prev diag error" })
        end,
    },
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
            placeholders_hl = "None",
        },
        cmd = "Neogen",
        keys = { { "<leader>ln", ":Neogen<CR>", desc = "Annotate" } },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
    },
    {
        "Wansmer/sibling-swap.nvim",
        lazy = true,
        keys = {
            {
                "[a",
                function()
                    require("sibling-swap").swap_with_left()
                end,
                desc = "Swap node with left",
            },
            {
                "]a",
                function()
                    require("sibling-swap").swap_with_right()
                end,
                desc = "Swap node with right",
            },
        },
        opts = {
            use_default_keymaps = false,
        },
    },
}
