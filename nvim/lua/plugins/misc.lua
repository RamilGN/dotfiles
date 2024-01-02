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
        lazy = false,
        keys = require("config.keymaps").oil(),
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            skip_confirm_for_simple_edits = true,
            win_options = {
                concealcursor = "nvic",
            },
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["~"] = false,
                ["<C-l>"] = false,
                ["<C-s>"] = false,
                ["<C-h>"] = false,
                ["gg"] = {
                    desc = "Go to home",
                    callback = function()
                        vim.cmd("edit $HOME")
                    end,
                },
                ["<C-Space>"] = "actions.close",
                ["gr"] = "actions.refresh",
                ["gv"] = "actions.select_vsplit",
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
            },
        },
    },
    -- Terminal management.
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec" },
        commit = "c80844fd52ba76f48fabf83e2b9f9b93273f418d",
        config = function()
            local toggleterm = require("toggleterm")

            toggleterm.setup({
                size = function(_)
                    return math.floor(vim.o.columns * 0.5)
                end,
                open_mapping = [[<C-\>]],
                insert_mappings = true,
                shade_terminals = false,
                persist_size = false,
                persist_mode = false,
                direction = "float",
                float_opts = { border = "rounded" },
                auto_scroll = true,
            })

            local kitty_columns = 98
            local kitty = "kitty @ send-text --match neighbor:right --stdin "
            local termid = 22
            vim.api.nvim_create_user_command("SendCurrentLineToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    local text = vim.api.nvim_get_current_line()
                    os.execute(kitty .. "<<EOF\n" .. text .. "\nEOF\n")
                else
                    toggleterm.send_lines_to_terminal("single_line", false, { args = termid })
                end
            end, {})

            vim.api.nvim_create_user_command("SendVisualSelectionToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    local utils = require("toggleterm.utils")
                    local res = utils.get_line_selection("visual")
                    local lines = utils.get_visual_selection(res)

                    for _, line in ipairs(lines) do
                        os.execute("kitty @ send-text --match neighbor:right --stdin <<EOF\n" .. line .. "\nEOF\n")
                    end
                else
                    toggleterm.send_lines_to_terminal("visual_selection", false, { args = termid })
                end
            end, { range = true })

            vim.api.nvim_create_user_command("SendQToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    os.execute(kitty .. "<<EOF\nq\nEOF\n")
                else
                    toggleterm.exec_command("cmd=q", termid)
                end
            end, {})

            vim.api.nvim_create_user_command("SendSpaceToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    os.execute(kitty .. "<<EOF\n \nEOF\n")
                else
                    toggleterm.exec_command("cmd= ", termid)
                end
            end, {})
        end,
        keys = require("config.keymaps").toggleterm(),
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
                    win_height = 999,
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
        cmd = { "YAMLTelescope" },
    },
    {
        "robitx/gp.nvim",
        config = function()
            require("gp").setup()
        end,
    },
}
