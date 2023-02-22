return {
    -- Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            local fortune = require("alpha.fortune")()
            local plugins = require("lazy.stats").stats().count

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
                    { type = "padding", val = 10 },
                    dashboard.section.header,
                    { type = "text",    val = info, opts = { position = "center" } },
                    { type = "padding", val = 2 },
                    {
                        type = "group",
                        val = {
                            dashboard.button("n", "  New file", "<Cmd>enew | startinsert<CR>"),
                            dashboard.button("s", "  Search word", "<Cmd>Telescope live_grep<CR>"),
                            dashboard.button("f", "  Find files", "<Cmd>Telescope find_files<CR>"),
                            dashboard.button("r", "  Recent files", "<Cmd>Telescope oldfiles cwd_only=true<CR>"),
                            dashboard.button("a", "  All files", "<Cmd>Telescope find_files cwd=~<CR>"),
                            dashboard.button("g", "  Git status", "<Cmd>silent! Telescope git_status<CR>"),
                            dashboard.button("i", "  Private", "<Cmd>Telescope find_files cwd=~/private<CR>"),
                            dashboard.button("c", "  Configuration", "<Cmd>Telescope find_files cwd=~/dotfiles<CR>"),
                            dashboard.button("p", "  Update plugins", "<Cmd>PackerSync<CR>"),
                            dashboard.button("q", "  Quit", ":qa!<CR>"),
                        },
                        opts = { spacing = 0 },
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
    },

    -- Theme
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                variablebuiltinStyle = { italic = true },
                specialReturn = true,
                specialException = true,
                transparent = true,
                dimInactive = false,
                globalStatus = false,
                terminalColors = true,
                colors = {},
                overrides = {
                    Pmenu = { blend = 17 }
                },
            })
            vim.cmd("colorscheme kanagawa")
        end
    },

    -- Displaying icons
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
        end
    },

    -- Fancy lower statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                    }
                end
            end

            require("lualine").setup({
                options = {
                    theme = "kanagawa",
                    component_separators = {},
                    section_separators = {}
                },
                sections = {
                    lualine_b = { { "diff", source = diff_source } },
                    lualine_c = { "%f" },
                    lualine_z = { "%l:%v" }
                },
                extensions = { "nvim-tree", "quickfix" }
            })
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Fancy tabs
    {
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Displaying indents
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_trailing_blankline_indent = false,
                show_current_context = true,
                filetype_exclude = {
                    "help",
                    "packer",
                    "neo-tree"
                },
                context_patterns = {
                    "class",
                    "return",
                    "function",
                    "method",
                    "^if",
                    "^while",
                    "^for",
                    "^object",
                    "^table",
                    "block",
                    "arguments",
                    "if_statement",
                    "else_clause",
                    "jsx_element",
                    "jsx_self_closing_element",
                    "try_statement",
                    "catch_clause",
                    "import_statement",
                    "operation_type",
                },
            })
        end
    },

    -- Displaying colors
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    },

    -- Better select ui
    {
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
    },

    -- Autocompletion symbols
    { "onsails/lspkind.nvim" },

    -- LSP status
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end
    }
}
