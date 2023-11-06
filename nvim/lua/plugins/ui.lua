return {
    -- Theme.
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                on_highlights = function(hl, c)
                    hl.CursorLineNr = { fg = c.orange, bold = true }
                    hl.GitSignsAdd = { fg = c.teal }
                    hl.GitSignsChange = { fg = c.yellow }
                    hl.GitSignsDelete = { fg = c.red1 }
                end,
            })
            vim.cmd([[colorscheme tokyonight-moon]])
        end,
    },
    -- Fancy lower status line.
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
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
                    theme = "tokyonight",
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
                        {
                            function()
                                return require("nvim-navic").get_location()
                            end,
                            cond = function()
                                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                            end,
                        },
                    },
                    lualine_x = {},
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
                    shortcut = { { desc = info } },
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
    -- Better tabs.
    {
        "alvarosevilla95/luatab.nvim",
        config = function()
            require("luatab").setup({
                modified = function()
                    return ""
                end,
                windowCount = function(index)
                    return "[" .. index .. "]" .. " "
                end,
            })
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
    -- UI components.
    { "MunifTanjim/nui.nvim", lazy = true },
}
