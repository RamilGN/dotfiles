return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    require("treesitter-context").setup({
                        patterns = {
                            default = {
                                "class",
                                "function",
                                "method",
                                "for",
                                "while",
                                "if",
                                "else",
                                "switch",
                                "case"
                            },
                            javascript = {
                                "object",
                                "pair"
                            },
                            ruby = {
                                "module",
                                "block"
                            },
                            yaml = {
                                "block_mapping_pair",
                                "block_sequence_item"
                            },
                            json = {
                                "object",
                                "pair",
                            },
                        },
                    })
                end
            },
            { "RRethy/nvim-treesitter-endwise" },
            { "windwp/nvim-ts-autotag" },
            {
                "danymat/neogen",
                config = function()
                    require("neogen").setup({
                        snippet_engine = "luasnip",
                        placeholders_hl = "None",
                    })
                end
            }
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "ruby",
                    "sql",
                    "lua",
                    "go",
                    "python",
                    "javascript",
                    "html",
                    "markdown",
                    "query",
                    "vim",
                    "help",
                    "comment"
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
                }
            })
        end
    }
}
