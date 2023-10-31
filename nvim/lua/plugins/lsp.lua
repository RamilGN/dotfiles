return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
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
                keys = require("config.keymaps").mason(),
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
                },
                signs = {
                    DiagnosticSignError = { text = " ", texthl = "DiagnosticSignError" },
                    DiagnosticSignWarn = { text = " ", texthl = "DiagnosticSignWarn" },
                    DiagnosticSignInfo = { text = " ", texthl = "DiagnosticSignInfo" },
                    DiagnosticSignHint = { text = " ", texthl = "DiagnosticSignHint" },
                },
            },

            on_attach = function(client, bufnr)
                local k = require("config.keymaps")
                k.lsp(bufnr, client)
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
                    options.on_attach = function(client, bufnr)
                        -- Too slow for me :(
                        if vim.fn.expand("%:p"):find("insales/insales") then
                            client.server_capabilities.completionProvider = false
                        end
                        opts.on_attach(client, bufnr)
                    end
                end,
                lua_ls = function(options, _)
                    options.settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    }
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
                            usePlaceholders = true,
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

            -- TODO: Run only if ruby lsp is present
            require("wip.ruby").setup()
            require("neodev").setup()

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
