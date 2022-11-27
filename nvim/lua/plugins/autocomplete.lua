local M = {}

function M.setup(use)
    -- Autocomplete extensions
    use({
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        requires = { "hrsh7th/nvim-cmp" }
    })

    -- Autocomplete engine
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            local utils = require("utils")
            local cmp = require("cmp")
            local cmp_buffer = require("cmp_buffer")
            local luasnip = require("luasnip")

            local buffer_source = {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            local byte_size = utils.get_buf_byte_size(buf)
                            if byte_size < vim.g.max_byte_size then
                                bufs[buf] = true
                            end
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
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-2),
                    ["<C-d>"] = cmp.mapping.scroll_docs(2),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
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
end

return M
