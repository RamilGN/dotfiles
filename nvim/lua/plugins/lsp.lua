return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- Package manager
            {
                "williamboman/mason.nvim",
                config = function()
                    require("mason").setup()

                    require("mason-lspconfig").setup({
                        ensure_installed = {
                            "bashls",
                            "cssls",
                            "dockerls",
                            "emmet_ls",
                            "eslint",
                            "gopls",
                            "html",
                            "jsonls",
                            "lua_ls",
                            "pylsp",
                            "pyright",
                            "solargraph",
                            "tsserver",
                            "yamlls",
                        },
                    })
                end,
                cmd = "Mason",
            },
            { "williamboman/mason-lspconfig.nvim" },
            -- JSON schemas
            { "b0o/schemastore.nvim" },
        },
        opts = {
            diagnostics = {
                config = {
                    virtual_text = false,
                    update_in_insert = false,
                    underline = true,
                    severity_sort = true,
                    float = {
                        source = "always",
                    },
                },
                signs = {
                    DiagnosticSignError = { text = " ", texthl = "DiagnosticSignError" },
                    DiagnosticSignWarn = { text = " ", texthl = "DiagnosticSignWarn" },
                    DiagnosticSignInfo = { text = " ", texthl = "DiagnosticSignInfo" },
                    DiagnosticSignHint = { text = " ", texthl = "DiagnosticSignHint" },
                },
            },

            on_attach = function(client, bufnr)
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                map("n", "<C-q>", "<Cmd>Telescope lsp_document_symbols<CR>", "LSP document symbols")
                map("n", "<leader>li", "<Cmd>LspInfo<CR>", "Lsp info")
                map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>lw", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols")
                map("n", "<leader>lx", "<Cmd>LspRestart<CR>", "Lsp restart")
                map("n", "K", vim.lsp.buf.hover, "Hover")
                map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                map("n", "gI", "<Cmd>Telescope lsp_implementations<CR>", "Go to Implementation")
                map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
                map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", "Go to definition")
                map("n", "gr", "<Cmd>Telescope lsp_references<CR>", "Show references")
                map("n", "gy", "<Cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition")
                map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code actions")

                -- if not vim.lsp.inlay_hint.is_enabled() then
                --     vim.lsp.inlay_hint.enable()
                -- end
            end,
            servers = {
                jsonls = function(options, _)
                    options.settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        },
                    }
                end,
                yamlls = function(options, _)
                    options.settings = {
                        yaml = {
                            schemas = require("schemastore").yaml.schemas(),
                            keyOrdering = false,
                        },
                    }
                end,
                solargraph = function(options, opts)
                    opts.settings = {
                        solargraph = {
                            diagnostics = false,
                        },
                    }

                    options.on_attach = function(client, bufnr)
                        opts.on_attach(client, bufnr)
                    end
                end,
                gopls = function(options)
                    options.settings = {
                        gopls = {
                            gofumpt = true,
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            analyses = {
                                -- fieldalignment = true,
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                            },
                            -- usePlaceholders = true,
                            completeUnimported = true,
                            staticcheck = true,
                            directoryFilters = { "-.git", "-node_modules" },
                            semanticTokens = true,
                        },
                    }
                end,
            },
        },
        config = function(_, opts)
            for sign, value in pairs(opts.diagnostics.signs) do
                vim.fn.sign_define(sign, value)
            end
            vim.diagnostic.config(opts.diagnostics.config)

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            for _, server_name in ipairs(require("mason-lspconfig").get_installed_servers()) do
                local lsp_opts = {
                    on_attach = opts.on_attach,
                    capabilities = capabilities,
                }

                if opts.servers[server_name] then
                    opts.servers[server_name](lsp_opts, opts)
                end

                lspconfig[server_name].setup(lsp_opts)
            end
        end,
    },
}
