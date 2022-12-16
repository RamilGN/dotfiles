local M = {}

function M.setup(use)
    use(
        {
            {
                "williamboman/mason.nvim",
                config = function()
                    require("mason").setup({
                        ui = {
                            icons = {
                                package_installed = "✓",
                                package_pending = "➜",
                                package_uninstalled = "✗"
                            }
                        }
                    })
                end
            },
            "williamboman/mason-lspconfig.nvim",
            "b0o/schemastore.nvim",
            {
                "neovim/nvim-lspconfig",
                config = function()
                    local wk = require("which-key")
                    local capabilities = require("cmp_nvim_lsp").default_capabilities()
                    local lspconfig = require("lspconfig")
                    local schemastore = require("schemastore")
                    local mason_lsp_config = require("mason-lspconfig")

                    local additional_opts = {
                        ["jsonls"] = function(options)
                            options.settings = {
                                json = {
                                    schemas = schemastore.json.schemas(),
                                    validate = { enable = true }
                                }
                            }
                        end,
                    }

                    local on_attach = function(_, bufnr)

                        local keymaps = {
                            buffer = bufnr,
                            ["K"] = { vim.lsp.buf.hover, "Hover" },

                            -- Fast shortcuts
                            ["<C-q>"] = { "<Cmd>Telescope lsp_document_symbols<CR>", "Live grep" },

                            ["g"] = {
                                ["d"] = { "<Cmd>Telescope lsp_definitions<CR>", "Go to defenition" },
                                ["D"] = { "<Cmd>Telescope lsp_declarations<CR>", "Go to declaration" },
                                ["r"] = { "<Cmd>Telescope lsp_references<CR>", "Show references" },
                                ["I"] = { "<Cmd>Telescope lsp_implementations<CR>", "Go to Implementation" },
                                ["T"] = { "<Cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition" },
                            },

                            ["<leader>"] = {
                                name = "+SPC",
                                ["l"] = {
                                    name = "+LSP",
                                    ["l"] = {
                                        ["i"] = { "<Cmd>LspInfo<CR>", "Lsp info" },
                                        ["r"] = { "<Cmd>LspRestart<CR>", "Lsp restart" },
                                        ["a"] = { "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
                                        ["d"] = { "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
                                        ["l"] = { "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Folders" },
                                    },
                                    ["r"] = { vim.lsp.buf.rename, "Rename" },
                                    ["a"] = {
                                        { vim.lsp.buf.code_action, "Code actions" },
                                        { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions", mode = "v" },
                                    },
                                    ["d"] = { vim.diagnostic.open_float, "Open diagnostic float window" },
                                    ["D"] = { "<Cmd>Telescope diagnostics<CR>", "Diagnostic" },
                                    ["f"] = {
                                        {
                                            function() vim.lsp.buf.format({ async = true }) end,
                                            "Format",
                                        },
                                        {
                                            function() vim.lsp.buf.format({ async = true }) end,
                                            "Range format",
                                            mode = "v",
                                        }
                                    },
                                    ["w"] = { "<Cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols" },
                                },

                            }
                        }

                        wk.register(keymaps)
                    end

                    mason_lsp_config.setup({
                        ensure_installed = {
                            "sumneko_lua",
                            "solargraph",
                            "gopls",
                            "sqlls",
                            "pylsp",
                            "pyright",
                            "dockerls",
                            "bashls",
                            "eslint",
                            "html",
                            "cssls",
                            "jsonls",
                            "yamlls",
                            "dockerls"
                        }
                    })


                    for _, server_name in ipairs(mason_lsp_config.get_installed_servers()) do
                        local lsp_opts = {
                            on_attach = on_attach,
                            capabilities = capabilities,
                        }
                        if additional_opts[server_name] then
                            additional_opts[server_name](lsp_opts)
                        end
                        lspconfig[server_name].setup(lsp_opts)
                    end

                end
            }
        })

    use(
        {
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                local null_ls = require("null-ls")
                require("null-ls").setup({
                    sources = {
                        null_ls.builtins.diagnostics.markdownlint
                    },
                })
            end
        }
    )
end

return M
