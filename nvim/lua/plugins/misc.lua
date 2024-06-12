return {
    -- Popup with suggestions to complete a key binding.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>ga"] = { name = "+add" },
                ["<leader>gc"] = { name = "+commit" },
                ["<leader>gi"] = { name = "+info/show" },
                ["<leader>gl"] = { name = "+log" },
                ["<leader>go"] = { name = "+open" },
                ["<leader>gs"] = { name = "+stash/stage" },
                ["<leader>gy"] = { name = "+yank/open" },
                ["<leader>gp"] = { name = "+push/pull" },
                ["<leader>p"] = { name = "+plugins/packages" },
                ["<leader>l"] = { name = "+lsp/action" },
                ["<leader>r"] = { name = "+run" },
                ["<leader>m"] = { name = "+mind" },
                ["<leader>o"] = { name = "+other" },
                ["<leader>h"] = { name = "+help" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    -- File explorer.
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = require("config.keymaps").oil.keys(),
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            delete_to_trash = true,
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            },
            keymaps = require("config.keymaps").oil.explorer(),
        },
    },
    -- Markdown.
    {
        "iamcco/markdown-preview.nvim",
        build = vim.fn["mkdp#util#install"],
        cmd = "MarkdownPreviewToggle",
        event = { "BufReadPost", "BufNewFile" },
        keys = require("config.keymaps").markdown_preview,
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
        cmd = { "YAMLTelescope" },
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
    -- Modifiable qf.
    {
        "stefandtw/quickfix-reflector.vim",
        ft = "qf",
    },
}
