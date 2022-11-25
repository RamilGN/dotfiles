local M = {}

function M.setup(use)
    -- Theme
    use({
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "storm",
                on_highlights = function(hl, c)
                    hl.CursorLineNr = { fg = c.orange, bold = true }
                    hl.GitSignsAdd = { fg = c.teal }
                    hl.GitSignsChange = { fg = c.yellow }
                    hl.GitSignsDelete = { fg = c.red1 }
                    hl.WinSeparator = { bg = c.bg, fg = c.bg }
                end
            })
            vim.cmd([[colorscheme tokyonight]])
        end
    })

    -- Displaying icons
    use({
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
        end
    })

    -- Fancy lower statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    component_separators = {},
                    section_separators = {}
                },
                sections = {
                    lualine_c = { "%f" },
                    lualine_z = { "%l:%v" }
                },
                extensions = { "nvim-tree" }
            })
        end
    })

    -- Fancy tabs
    use({
        "alvarosevilla95/luatab.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("luatab").setup {
                modified = function()
                    return ""
                end,
                windowCount = function(index)
                    return "[" .. index .. "]" .. " "
                end,
                devicon = function()
                    return ""
                end
            }
        end
    })

    -- Displaying indents
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                char = "┊",
                show_trailing_blankline_indent = false,
                filetype_exclude = {
                    "help",
                    "packer",
                    "neo-tree"
                }
            })
        end
    })

    -- Displaying colors
    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    })

    -- Better select ui
    use({
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({
                input = {
                    get_config = function()
                        if vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
                            return { min_width = 140 }
                        end
                    end
                }
            })

            vim.keymap.set("n", "z=", function()
                local word = vim.fn.expand("<cword>")
                local suggestions = vim.fn.spellsuggest(word)
                vim.ui.select(suggestions, {},
                    vim.schedule_wrap(function(selected)
                        if selected then
                            vim.api.nvim_feedkeys("ciw" .. selected, "n", true)
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
                        end
                    end)
                )
            end)
        end
    })

    -- Autocompletion symbols
    use({ "onsails/lspkind.nvim" })
end

return M
