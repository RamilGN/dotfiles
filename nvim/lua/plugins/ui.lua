return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = true,
                undercurl = true,
                specialReturn = true,
                specialException = true,
                transparent = false,
                globalStatus = true,
                terminalColors = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme

                    return {
                        -- Transparent Floating Windows
                        NormalFloat = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        FloatTitle = { bg = "none" },
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        -- More uniform colors for the popup menu.
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                        -- Borderless old messages
                        MsgSeparator = { bg = "none" },
                    }
                end,
            })

            vim.cmd("colorscheme kanagawa-dragon")
        end,
    },
    -- Fancy lower status line.
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function(_, opts)
            require("lualine").setup(opts)
        end,
        opts = function()
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            local function diff_source()
                ---@diagnostic disable-next-line: undefined-field
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end

            return {
                options = {
                    theme = "kanagawa",
                    globalstatus = true,
                    component_separators = {},
                    section_separators = {},
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "branch" }, { "diff", source = diff_source } },
                    lualine_c = {
                        { "diagnostics" },
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = {
                                left = 1,
                                right = 0,
                            },
                        },
                        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.mode.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                            separator = "",
                            color = { gui = "bold", fg = "#ff9e3b" },
                        },
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.command.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                            color = { gui = "bold", fg = "#ff9e3b" },
                        },
                    },
                    lualine_y = {},
                    lualine_z = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                extensions = { "nvim-tree", "quickfix", "toggleterm", "fugitive", "man" },
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
            draw = {
                animation = function()
                    return 0
                end,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "toggleterm",
                    "undotree",
                    "oil_preview",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end,
    },

    -- Highlight word under cursor.
    {
        "echasnovski/mini.cursorword",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },

    -- Better select UI
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- Dashboard
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        config = function()
            local v = vim.version()
            local info = string.format("v%d.%d.%d", v.major, v.minor, v.patch)
            require("dashboard").setup({
                theme = "hyper",
                config = {
                    header = {
                        "                                                   ",
                        "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                        "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                        "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                        "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                        "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                        "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                        "                                                   ",
                    },
                    project = { enable = false },
                    shortcut = { { desc = info } },
                    mru = { limit = 20, cwd_only = true },
                    footer = {},
                },
            })
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
    -- `TODO` comments.
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        config = true,
        -- stylua: ignore
        keys = {
            { "]t",        function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",        function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>t", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
            { "<leader>T", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
        },
    },
    -- Displaying colors.
    {
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },
    -- Autocompletion symbols.
    { "onsails/lspkind.nvim", lazy = true },
    -- Displaying icons.
    { "nvim-tree/nvim-web-devicons", lazy = true },
    -- Cmdline
    {

        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            cmdline = {
                view = "cmdline",
            },
            presets = {
                bottom_search = true,
                command_palette = true,
            },
        },
        -- stylua: ignore
        keys = {
            { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline", },
            { "<C-'>", function() require("noice").cmd("all") end, desc = "All messages" },

        },
        dependencies = { "MunifTanjim/nui.nvim", },
    },
}
