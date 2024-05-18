-- Telescope
return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = require("config.keymaps").telescope,
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
            local delta_previewer = previewers.new_termopen_previewer({
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
                    preview = {
                        treesitter = {
                            disable = { "eruby" }, -- 100% memory WTF 0_0
                        },
                    },
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
                        previewer = delta_previewer,
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
