return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            {
                "nvim-treesitter/playground",
                cmd = "TSPlaygroundToggle"
            },
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    require("treesitter-context").setup()
                end
            },
            { "RRethy/nvim-treesitter-endwise" },
            { "windwp/nvim-ts-autotag" },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "go",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
                    "ruby",
                    "sql",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = function(_, bufnr)
                        local f = require("functions")
                        return f.vim.get_buf_byte_size(bufnr) > vim.g.max_byte_size
                    end
                },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ar"] = "@block.outer",
                            ["ir"] = "@block.inner",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["]a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["[a"] = "@parameter.inner",
                        }
                    }
                },
                endwise = {
                    enable = true
                },
                autotag = {
                    enable = true
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
                }
            })

            local f = require("functions")
            local tsrm = require "nvim-treesitter.textobjects.repeatable_move"
            local next_diag_repeat, prev_diag_repeat = tsrm.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
            local next_spell_repeat, prev_spell_repeat = tsrm.make_repeatable_move_pair(function() f.vim.keys("]s") end, function() f.vim.keys("[s") end)

            vim.keymap.set({ "n", "x", "o" }, ";", tsrm.repeat_last_move)
            vim.keymap.set({ "n", "x", "o" }, ",", tsrm.repeat_last_move_opposite)
            vim.keymap.set({ "n", "x", "o" }, "f", tsrm.builtin_f)
            vim.keymap.set({ "n", "x", "o" }, "F", tsrm.builtin_F)
            vim.keymap.set({ "n", "x", "o" }, "t", tsrm.builtin_t)
            vim.keymap.set({ "n", "x", "o" }, "T", tsrm.builtin_T)
            vim.keymap.set("n", "]s", next_spell_repeat, { desc = "Next spell error" })
            vim.keymap.set("n", "[s", prev_spell_repeat, { desc = "Prev spell error" })
            vim.keymap.set("n", "]d", next_diag_repeat, { desc = "Next diag error" })
            vim.keymap.set("n", "[d", prev_diag_repeat, { desc = "Prev diag error" })
        end
    },
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
            placeholders_hl = "None",
        },
        keys = require("config.keymaps").neogen()
    }

}
