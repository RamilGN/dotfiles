local M = {}

function M.setup(use)
    -- Dashboard
    use {
        "goolord/alpha-nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            local fortune = require("alpha.fortune")()

            local plugins = #vim.tbl_keys(packer_plugins)
            local v = vim.version()
            local info = string.format(" %d v%d.%d.%d", plugins, v.major, v.minor, v.patch)
            local header = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                     ",
            }
            dashboard.section.header.val = header
            dashboard.section.footer.val = fortune

            local config = {
                layout = {
                    { type = "padding", val = 2 },
                    dashboard.section.header,
                    { type = "text", val = info, opts = { position = "center" } },
                    { type = "padding", val = 2 },
                    {
                        type = "group",
                        val = {
                            dashboard.button("n", "  New file", "<Cmd>enew | startinsert<CR>"),
                            dashboard.button("s", "  Search word", "<Cmd>Telescope live_grep<CR>"),
                            dashboard.button("f", "  Find files", "<Cmd>Telescope find_files<CR>"),
                            dashboard.button("r", "  Recent files", "<Cmd>Telescope oldfiles cwd_only=true<CR>"),
                            dashboard.button("g", "  Git status", "<Cmd>silent! Telescope git_status<CR>"),
                            dashboard.button("p", "  Private", "<Cmd>Telescope find_files cwd=~/private<CR>"),
                            dashboard.button("c", "  Configuration", "<Cmd>silent! Telescope find_files cwd=~/dotfiles<CR>"),
                            dashboard.button("u", "  Update plugins", "<Cmd>PackerSync<CR>"),
                            dashboard.button("q", "  Quit", ":qa!<CR>"),
                        },
                        opts = { spacing = 1 },
                    },

                    { type = "padding", val = 1 },
                    dashboard.section.footer,
                },
                opts = {
                    margin = 5,
                },
            }

            require("alpha").setup(config)
        end
    }

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
        end,
        requires = { "kyazdani42/nvim-web-devicons" },
    })

    -- Fancy tabs
    use({
        "alvarosevilla95/luatab.nvim",
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
        end,
        requires = { "kyazdani42/nvim-web-devicons" },
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
