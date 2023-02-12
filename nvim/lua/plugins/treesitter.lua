local M = {}

function M.setup(use)
    -- Treesitter
    use(
        {
            { "nvim-treesitter/nvim-treesitter-context",
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
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "windwp/nvim-ts-autotag" },
            { "danymat/neogen",
                config = function()
                    require("neogen").setup({
                        snippet_engine = "luasnip",
                        placeholders_hl = "None",
                    })
                end
            },
            {
                "nvim-treesitter/nvim-treesitter",
                run = function()
                    local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
                    ts_update()
                end,
                config = function()
                    require("nvim-treesitter.configs").setup({
                        incremental_selection = {
                            enable = true,
                            keymaps = {
                                init_selection = "grv",
                                node_incremental = "grn",
                                scope_incremental = "grc",
                                node_decremental = "grm",
                            },
                        },
                        ensure_installed = "all",
                        sync_install = false,
                        highlight = {
                            enable = true,
                            disable = function(_, bufnr)
                                local f = require("functions")
                                return f.vim.get_buf_byte_size(bufnr) > vim.g.max_byte_size
                            end,
                        },
                        additional_vim_regex_highlighting = false,
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
    )
end

return M
