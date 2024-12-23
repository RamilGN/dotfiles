return {
    -- Popup with suggestions to complete a key binding.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            icons = { rules = false },
            plugins = { spelling = { enabled = true } },
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader>g", group = "git" },
                    { "<leader>ga", group = "add" },
                    { "<leader>gc", group = "commit" },
                    { "<leader>gi", group = "info/show" },
                    { "<leader>gl", group = "log" },
                    { "<leader>go", group = "open" },
                    { "<leader>gp", group = "push/pull" },
                    { "<leader>gs", group = "stash/stage" },
                    { "<leader>gy", group = "yank/open" },
                    { "<leader>h", group = "help" },
                    { "<leader>l", group = "lsp/action" },
                    { "<leader>m", group = "mind" },
                    { "<leader>o", group = "other" },
                    { "<leader>p", group = "plugins/packages" },
                    { "<leader>r", group = "run" },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
        end,
    },
    -- File explorer.
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = {
            {
                "<C-Space>",
                function()
                    local open = require("oil").open
                    if vim.bo.filetype == "fugitive" then
                        open(".")
                    else
                        open()
                    end
                end,
                desc = "Open file explorer",
                mode = { "t", "n" },
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            watch_for_changes = true,
            delete_to_trash = true,
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["~"] = false,
                ["<C-l>"] = false,
                ["<C-s>"] = false,
                ["<C-h>"] = false,
                ["g~"] = {
                    desc = "Go to home",
                    callback = function()
                        vim.cmd("edit $HOME")
                    end,
                },
                ["<C-Space>"] = "actions.close",
                ["gr"] = "actions.refresh",
                ["gv"] = "actions.select_vsplit",
                ["gc"] = "actions.change_sort",
                ["gs"] = "actions.select_split",
                ["g."] = "actions.open_cmdline",
                ["gh"] = "actions.toggle_hidden",
                ["gx"] = "actions.open_external",
                ["gd"] = {
                    desc = "Toggle detail view",
                    callback = function()
                        local oil = require("oil")
                        local config = require("oil.config")
                        if #config.columns == 1 then
                            oil.set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            oil.set_columns({ "icon" })
                        end
                    end,
                },
                ["gq"] = "actions.send_to_qflist",
            },
        },
    },
    -- Markdown.
    {
        "iamcco/markdown-preview.nvim",
        build = vim.fn["mkdp#util#install"],
        cmd = "MarkdownPreviewToggle",
        event = { "BufReadPost", "BufNewFile" },
        ft = "markdown",
    },
    -- YAML.
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim",
        },
        keys = require("config.keymaps").yaml,
        cmd = { "YAMLTelescope", "YAMLView", "YAMLYank", "YAMLYankKey", "YAMLYankValue", "YAMLQuickfix" },
    },
    -- Flat nvim sessions.
    {
        "willothy/flatten.nvim",
        opts = {
            window = {
                open = "alternate",
            },
        },
        lazy = false,
        priority = 1001,
    },
    -- Enchanced qf.
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },
        },
    },
    -- Neovim dev.
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    -- Lua
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            plugins = {
                options = {
                    laststatus = 0,
                },
                kitty = {
                    enabled = true,
                    font = "+4",
                },
            },
        },
    },
}
