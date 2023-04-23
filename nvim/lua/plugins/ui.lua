return {
    -- TODO: LAZY

    -- Theme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
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
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none"
                            }
                        }
                    }
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = 12 },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                    }
                end
            })
            vim.cmd("colorscheme kanagawa")
        end
    },

    -- Fancy lower statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
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

            return {
                options = {
                    theme = "kanagawa",
                    component_separators = {},
                    section_separators = {},
                },
                sections = {
                    lualine_b = {
                        { "branch" },
                        { "diff",       source = diff_source },
                        { "diagnostics" },
                    },
                    lualine_c = {
                        {
                            function()
                                local cwd = vim.fn.getcwd()
                                return "[" .. cwd:match(".*/(.*)") .. "]"
                            end
                        },
                        { "%f" }
                    }
                },
                extensions = { "nvim-tree", "quickfix", "toggleterm", "fugitive", "man" }
            }
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Indent guide
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true },
            draw = { animation = function() return 0 end }
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, opts) require("mini.indentscope").setup(opts) end,
    },

    -- Better select UI
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- Dashboard
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")

            local header = {
                "                                                   ",
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                   ",
            }

            dashboard.section.header.val = header

            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                dashboard.button("l", "" .. " Plugins", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            dashboard.opts.layout[1].val = 8

            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    local v = vim.version()
                    local info = string.format(" v%d.%d ", v.major, v.minor)
                    dashboard.section.footer.val = info .. "loaded " .. stats.count .. " plugins in " .. ms .. "ms"

                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },

    -- Displaying colors
    { "norcalli/nvim-colorizer.lua", event = "VeryLazy", config = function() require("colorizer").setup() end },

    -- Autocompletion symbols
    { "onsails/lspkind.nvim", lazy = true },

    -- Displaying icons
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- UI components
    { "MunifTanjim/nui.nvim", lazy = true },

}
