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
                    local on_attach = function(_, bufnr)
                        local bufopts = { buffer = bufnr }
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                        vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>")
                        vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                        vim.keymap.set("n", "gp", vim.lsp.buf.implementation, bufopts)

                        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
                        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
                        vim.keymap.set("v", "<leader>ca", function() vim.lsp.buf.range_code_action() end, bufopts)
                        vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format({ async = true }) end, bufopts)
                        vim.keymap.set("v", "<leader>ff", function() vim.lsp.buf.range_formatting() end, bufopts)
                        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
                        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                        vim.keymap.set("n", "<leader>wl",
                            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
                    end


                    local mason_lsp_config = require("mason-lspconfig")
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

                    local enhance_server_opts = {
                        ["jsonls"] = function(options)
                            options.settings = {
                                json = {
                                    schemas = require("schemastore").json.schemas(),
                                    validate = { enable = true }
                                }
                            }
                        end,
                    }

                    local cpb = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
                    local lspconfig = require("lspconfig")
                    for _, server_name in ipairs(mason_lsp_config.get_installed_servers()) do
                        local lsp_opts = {
                            on_attach = on_attach,
                            capabilities = cpb,
                        }
                        if enhance_server_opts[server_name] then
                            enhance_server_opts[server_name](lsp_opts)
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
