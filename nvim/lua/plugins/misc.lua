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
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
            },
            keymaps = require("config.keymaps").oil.explorer(),
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
                hide_numbers = false,
                persist_size = false,
                persist_mode = false,
                direction = "float",
                float_opts = { border = "rounded" },
                auto_scroll = true,
            })

            local kitty_columns = 98
            local kitty = "kitty @ send-text --match neighbor:right "
            local termid = 22
            vim.api.nvim_create_user_command("SendCurrentLineToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    local text = vim.api.nvim_get_current_line()
                    text = text:gsub("'", [['\'']])
                    local command = kitty .. "-- '" .. text .. "\n'"
                    vim.fn.jobstart(command)
                else
                    toggleterm.send_lines_to_terminal("single_line", false, { args = termid })
                end
            end, {})

            vim.api.nvim_create_user_command("SendVisualSelectionToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    local utils = require("util")
                    local lines = utils.get_visual_selection_lines()

                    for _, line in ipairs(lines) do
                        local text = line:gsub("'", [['\'']])
                        local command = kitty .. "-- '" .. text .. "\n'"
                        vim.fn.jobstart(command)
                    end
                else
                    toggleterm.send_lines_to_terminal("visual_selection", false, { args = termid })
                end
            end, { range = true })

            vim.api.nvim_create_user_command("SendQToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    os.execute(kitty .. "'" .. "q" .. "\n'")
                else
                    toggleterm.exec_command("cmd=q", termid)
                end
            end, {})

            vim.api.nvim_create_user_command("SendSpaceToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    os.execute(kitty .. "'" .. " " .. "\n'")
                else
                    toggleterm.exec_command("cmd= ", termid)
                end
            end, {})

            vim.api.nvim_create_user_command("SendClearToTerm", function(_)
                if vim.o.columns == kitty_columns then
                    os.execute(kitty .. "'" .. "\x0C" .. "\n'")
                else
                    toggleterm.exec_command("cmd=q", termid)
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
        cmd = { "GptChatToggle", "GptChatNew", "GptEnew", "GptRewrite", "GptImplement" },
        keys = require("config.keymaps").gpt(),
        opts = {
            cmd_prefix = "Gpt",
            chat_user_prefix = "==>",
            chat_assistant_prefix = { "<==" },
            chat_free_cursor = true,
        },
    },
}
