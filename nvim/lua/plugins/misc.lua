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
                ["<leader>m"] = { name = "+misc" },
                ["<leader>o"] = { name = "+open/toggle" },
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
        lazy         = false,
        keys         = require("config.keymaps").oil(),
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts         = {
            skip_confirm_for_simple_edits = true,
            win_options = {
                concealcursor = "nvic",
            },
            view_options = {
                show_hidden = true
            },
            keymaps = {
                ["~"] = "<cmd>edit $HOME<CR>",
                ["<C-Space>"] = "actions.close",
                ["<C-l>"] = false,
                ["gr"] = "actions.refresh",
                ["<C-s>"] = false,
                ["gv"] = "actions.select_vsplit",
                ["<C-h>"] = false,
                ["gs"] = "actions.select_split",
                ["g."] = "actions.open_cmdline",
                ["go"] = {
                    desc = "Open with default app",
                    callback = function()
                        local oil = require("oil")
                        local cwd = oil.get_current_dir()
                        local entry = oil.get_cursor_entry()
                        if cwd and entry then
                            vim.fn.jobstart({ "xdg-open", string.format("%s/%s", cwd, entry.name) })
                        end
                    end
                },
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
            }
        },
    },
    -- Terminal management.
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec" },
        config = function()
            local toggleterm = require("toggleterm")

            toggleterm.setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 20
                    elseif term.direction == "vertical" then
                        return math.floor(vim.o.columns * 0.5)
                    end
                end,
                open_mapping = [[<C-\>]],
                insert_mappings = true,
                persist_size = false,
                persist_mode = false,
                direction = "float",
                float_opts = {
                    border = "rounded",
                },
                auto_scroll = true
            })

            vim.api.nvim_create_user_command("ToggleTermSendCurrentLineNoTW",
                function(opts)
                    toggleterm = require("toggleterm")

                    toggleterm.send_lines_to_terminal("single_line", false, opts)
                end,
                { nargs = "?" }
            )

            vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionNoTW",
                function(opts)
                    toggleterm = require("toggleterm")

                    toggleterm.send_lines_to_terminal("visual_selection", false, opts)
                end,
                { range = true, nargs = "?" }
            )
        end,
        keys = require("config.keymaps").toggleterm()
    },
    -- Better quickfix-list.
    {
        "kevinhwang91/nvim-bqf",
        ft = { "qf" },
        config = function()
            require("bqf").setup({
                preview = {
                    winblend = 0,
                    border = "none",
                    win_height = 999
                },
            })
        end,
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
        cmd = { "YAMLTelescope" }
    }
}
