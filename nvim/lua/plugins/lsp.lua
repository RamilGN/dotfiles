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
                            "solargraph",
                            "lua_ls",
                            "emmet_ls",
                            "gopls",
                            "pylsp",
                            "pyright",
                            "dockerls",
                            "bashls",
                            "tsserver",
                            "html",
                            "cssls",
                            "jsonls",
                            "yamlls",
                            "dockerls"
                        }
                    })
                end,
                cmd = "Mason",
                keys = require("config.keymaps").mason(),
            },
            { "williamboman/mason-lspconfig.nvim" },
            -- JSON schemas
            { "b0o/schemastore.nvim" },
            -- LSP status
            { "j-hui/fidget.nvim",                config = function() require("fidget").setup() end, tag = "legacy" },

        },
        config = function()
            -- Diagnositc signs
            vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

            -- Diagnositcs opts
            vim.diagnostic.config({
                virtual_text = false,
                update_in_insert = false,
                underline = true,
                severity_sort = true
            })

            local on_attach = function(client, bufnr)
                local keymaps = {
                    buffer = bufnr,
                    ["K"] = { vim.lsp.buf.hover, "Hover" },
                    -- Fast shortcuts
                    ["<C-q>"] = { "<Cmd>Telescope lsp_document_symbols<CR>", "Live grep" },
                    ["g"] = {
                        ["d"] = { "<Cmd>Telescope lsp_definitions<CR>", "Go to defenition" },
                        ["r"] = { "<Cmd>Telescope lsp_references<CR>", "Show references" },
                        ["y"] = { "<Cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition" },
                        ["I"] = { "<Cmd>Telescope lsp_implementations<CR>", "Go to Implementation" },
                        ["D"] = { "<Cmd>Telescope lsp_declarations<CR>", "Go to declaration" },
                    },
                    ["<leader>"] = {
                        name = "+spc",
                        ["l"] = {
                            name = "+lsp/action",
                            ["l"] = {
                                ["i"] = { "<Cmd>LspInfo<CR>", "Lsp info" },
                                ["r"] = { "<Cmd>LspRestart<CR>", "Lsp restart" },
                                ["a"] = { "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
                                ["d"] = { "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
                                ["l"] = { "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Folders" },
                            },
                            ["r"] = { vim.lsp.buf.rename, "Rename" },
                            ["a"] = {
                                { vim.lsp.buf.code_action,                  "Code actions" },
                                { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions", mode = "v" },
                            },
                            ["f"] = {
                                {
                                    function()
                                        vim.lsp.buf.format({ async = true })
                                    end,
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

                require("which-key").register(keymaps)
            end


            local server_opts = {
                ["jsonls"] = function(options)
                    options.settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true }
                        }
                    }
                end,
                ["yamlls"] = function(options)
                    options.settings = {
                        yaml = {
                            schemas = require("schemastore").yaml.schemas(),
                            keyOrdering = false
                        }
                    }
                end,
                ["solargraph"] = function(options)
                    options.on_attach = function(client, bufnr)
                        -- Too slow for me :(
                        client.server_capabilities.completionProvider = false
                        on_attach(client, bufnr)
                    end
                end,
                ["gopls"] = function(options)
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
                end
            }

            -- TODO: Run only if ruby lsp is present
            require("wip.ruby").setup()

            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            for _, server_name in ipairs(require("mason-lspconfig").get_installed_servers()) do
                local lsp_opts = {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }

                if server_opts[server_name] then
                    server_opts[server_name](lsp_opts)
                end

                lspconfig[server_name].setup(lsp_opts)
            end
        end
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local null_ls = require("null-ls")
            require("null-ls").setup({
                should_attach = function(bufnr)
                    local f = require("functions")
                    return f.vim.get_buf_byte_size(bufnr) < vim.g.max_byte_size
                end,
                sources = {
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.sqlfluff.with({
                        extra_args = { "--dialect", "postgres" }
                    }),
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.code_actions.gomodifytags,
                    null_ls.builtins.formatting.gofumpt.with({
                        extra_args = { "-extra" }
                    }),
                    null_ls.builtins.formatting.prettierd
                },
            })
        end
    }
}
