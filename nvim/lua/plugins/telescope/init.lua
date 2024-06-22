-- Telescope
return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = function()
            local t = function()
                return require("telescope.builtin")
            end

            local Util = function()
                return require("util.init")
            end

            local UtilVisual = function()
                return require("util.visual")
            end

            local UtilBuf = function()
                return require("util.buf")
            end

            return {
                -- Search.
                {
                    "<C-/>",
                    "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
                    desc = "Search buffer",
                },
                {
                    "<C-/>",
                    function()
                        t().current_buffer_fuzzy_find({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                    end,
                    desc = "Search buffer",
                    mode = "v",
                },
                {
                    "<C-m>",
                    "<Cmd>Telescope resume<CR>",
                    desc = "Telescope resume",
                },
                {
                    "<C-n>",
                    function()
                        t().find_files({ default_text = UtilBuf().get_cur_buf_dir_rel_path() })
                    end,
                    desc = "Show current dir",
                },
                {
                    "<C-b>",
                    "<Cmd>Telescope buffers<CR>",
                    desc = "Current buffers",
                },
                {
                    "<C-f>",
                    "<Cmd>Telescope find_files<CR>",
                    desc = "Find files",
                },
                {
                    "<C-f>",
                    function()
                        t().find_files({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                    end,
                    desc = "Find files",
                    mode = "v",
                },
                { "<C-s>", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
                {
                    "<C-s>",
                    function()
                        t().live_grep({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                    end,
                    desc = "Live grep",
                    mode = "v",
                },
                { "<C-;>", "<Cmd>Telescope command_history<CR>", desc = "Command history" },
                -- Git
                { "<C-g>", "<Cmd>silent! Telescope git_status<CR>", desc = "Git status" },
                { "<leader>gco", "<Cmd>Telescope git_branches<CR>", desc = "Git checkout" },
                { "<leader>gos", "<Cmd>Telescope git_stash<CR>", desc = "Git stash" },
                { "<leader>goc", "<Cmd>Telescope git_commits<CR>", desc = "Git commits" },
                { "<leader>goC", "<Cmd>Telescope git_bcommits<CR>", desc = "Git commits" },
                {
                    "<leader>gob",
                    function()
                        t().git_branches({ show_remote_tracking_branches = false })
                    end,
                    desc = "Git branches",
                },
                {
                    "<leader>goB",
                    function()
                        t().git_branches()
                    end,
                    desc = "Git branches all",
                },
                -- Help
                { "<leader>hc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
                { "<leader>hh", "<Cmd>Telescope help_tags<CR>", desc = "Help pages" },
                { "<leader>hk", "<Cmd>Telescope keymaps<CR>", desc = "Key maps" },
                { "<leader>hm", "<Cmd>Telescope man_pages<CR>", desc = "Man pages" },
                { "<leader>hf", "<Cmd>Telescope filetypes<CR>", desc = "File Types" },
                { "<leader>ht", "<Cmd>Telescope builtin<CR>", desc = "Telescope" },
                { "<leader>hs", "<Cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
                { "<leader>ho", "<Cmd>Telescope vim_options<CR>", desc = "Options" },
                -- Open
                { "<leader>oc", "<Cmd>Telescope find_files cwd=~/dotfiles<CR>", desc = "Open configs dir" },
                { "<leader>op", "<Cmd>Telescope find_files cwd=~/private<CR>", desc = "Open private dir" },
                { "<leader>o/", "<Cmd>Telescope search_history<CR>", desc = "Search history" },
                {
                    "<leader>or",
                    function()
                        t().oldfiles({ only_cwd = true })
                    end,
                    desc = "Open recent files",
                },
                { "<leader>od", "<Cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
                { "<leader>oy", "<Cmd>YAMLTelescope<CR>", desc = "Open yaml strings" },
                {
                    "<leader>os",
                    Util().input("Grep string", function(input)
                        t().grep_string({ search = input })
                    end),
                    desc = "Grep string",
                },
                {
                    "<leader>os",
                    function()
                        t().grep_string({ default_text = UtilVisual().get_visual_selection_for_telescope() })
                    end,
                    desc = "Grep string",
                    mode = "v",
                },
                { "<leader>ou", "<Cmd>Telescope undo<CR>", desc = "Undo history" },
            }
        end,
        config = function()
            local telescope = require("telescope")
            telescope.load_extension("undo")
            telescope.load_extension("fzf")

            local actions = require("telescope.actions")
            local telescope_config = require("telescope.config")

            local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")

            local force_delete_buffer = function(prompt_bufnr)
                local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function(selection)
                    local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = true })
                    return ok
                end)
            end

            local previewers = require("telescope.previewers")

            local git_status_previewer = previewers.new_termopen_previewer({
                -- {
                --   display = <function 1>,
                --   index = 5,
                --   ordinal = "?? foo.lua",
                --   path = "/home/ramilg/dotfiles/foo.lua",
                --   status = "??",
                --   value = "foo.lua"
                -- }

                get_command = function(entry)
                    if entry.status == "??" then
                        return "git diff --no-index /dev/null " .. entry.path
                    end

                    return "git diff HEAD -- '" .. entry.path .. "'"
                end,
            })

            local git_stash_previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
                    return "git stash show -p " .. entry.value
                end,
            })

            telescope.setup({
                defaults = {
                    wrap_results = true,
                    vimgrep_arguments = vimgrep_arguments,
                    mappings = {
                        i = {
                            ["<Esc>"] = actions.close,
                            ["<C-\\>"] = actions.close,
                            ["<C-j>"] = { "<C-^>", type = "command" },
                            ["<C-s>"] = actions.file_split,
                        },
                    },
                    dynamic_preview_title = true,
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                    live_grep = {
                        glob_pattern = { "!vendor" },
                    },
                    buffers = {
                        theme = "dropdown",
                        sorting_strategy = "ascending",
                        ignore_current_buffer = true,
                        sort_mru = true,
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                                ["<C-x>"] = force_delete_buffer,
                            },
                        },
                    },
                    git_branches = {
                        theme = "dropdown",
                        previewer = false,
                    },
                    git_status = {
                        previewer = git_status_previewer,
                    },
                    git_stash = {
                        previewer = git_stash_previewer,
                    },
                    lsp_workspace_symbols = {
                        symbol_width = 65,
                    },
                    lsp_document_symbols = {
                        symbol_width = 45,
                        theme = "dropdown",
                    },
                },
                extensions = {
                    undo = {
                        use_delta = true,
                    },
                },
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopePreviewerLoaded",
                callback = function(args)
                    if args.data.filetype ~= "help" then
                        vim.wo.wrap = true
                    end
                end,
            })
        end,
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    { "debugloop/telescope-undo.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
