local M = {}

function M.setup(use)
    -- ### Package manager
    use({
        "williamboman/mason.nvim",
        config = function()
            -- ### Package installer configuration
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
    })

    -- ### Prepare sources and snippet engine for autocompletion
    use({
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        requires = { "hrsh7th/nvim-cmp" }
    })

    -- ### Autocompletion
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            -- local utils = require("utils")
            local cmp = require("cmp")
            local cmp_buffer = require("cmp_buffer")
            local luasnip = require("luasnip")
            -- local ex_filetypes = {
            --     ["toggleterm"] = true,
            -- }
            local buffer_source = {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            bufs[vim.api.nvim_win_get_buf(win)] = true
                            -- local byte_size = utils.get_buf_byte_size(win)
                            -- local filetype = vim.api.nvim_buf_get_option(win, "filetype")
                            -- or ex_filetypes[filetype]
                            -- if byte_size > vim.g.max_byte_size then
                            --     table.remove(bufs, i)
                            -- end
                        end
                        return vim.tbl_keys(bufs)
                    end,
                    keyword_pattern = [[\k\+]]
                }
            }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- ### Mappings
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-2),
                    ["<C-d>"] = cmp.mapping.scroll_docs(2),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        -- behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    })
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lsp_document_symbol" },
                    buffer_source,
                    { name = "path" }
                },
                experimental = {
                    ghost_text = true,
                },
                formatting = {
                    format = require("lspkind").cmp_format(),
                },
                sorting = {
                    comparators = {
                        function(...) return cmp_buffer:compare_locality(...) end,
                    }
                }
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "cmdline" }
                })
            })

            for _, cmd_type in ipairs { "/", "?", } do
                cmp.setup.cmdline(
                    cmd_type, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        buffer_source
                    }
                })
            end
        end
    })

    -- ### LSP config
    use({
        "williamboman/mason-lspconfig.nvim",
        "b0o/schemastore.nvim",
        {
            "neovim/nvim-lspconfig",
            config = function()
                -- ### Diagnositc mappings
                local keymap_opts = { noremap = true, silent = true }
                vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, keymap_opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, keymap_opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, keymap_opts)

                -- ### Mappings
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
                    vim.keymap.set("v", "<leader>ca", function()
                        vim.lsp.buf.range_code_action()
                    end, bufopts)

                    vim.keymap.set("n", "<leader>ff", function()
                        vim.lsp.buf.format({ async = true })
                    end, bufopts)
                    vim.keymap.set("v", "<leader>ff", function()
                        vim.lsp.buf.range_formatting()
                    end, bufopts)

                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, bufopts)
                end

                -- ### Capabilities
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

                -- ### LSP servers configuration
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
                local installed_servers = mason_lsp_config.get_installed_servers()
                local lspconfig = require("lspconfig")

                -- ### Additional settings for certain LSP servers
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

                -- Setup LSP
                for _, server_name in ipairs(installed_servers) do
                    local lsp_opts = {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    }
                    if enhance_server_opts[server_name] then
                        enhance_server_opts[server_name](lsp_opts)
                    end
                    lspconfig[server_name].setup(lsp_opts)
                end
            end
        }
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            require("null-ls").setup({
                sources = {
                    null_ls.builtins.diagnostics.markdownlint
                },
            })
        end
    })
end

return M
