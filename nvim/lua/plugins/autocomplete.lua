return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "saadparwaiz1/cmp_luasnip" }
        },
        config = function()
            local f = require("functions")
            local cmp = require("cmp")

            local luasnip = require("luasnip")
            require("luasnip.loaders.from_snipmate").lazy_load()

            local buffer_source = {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            local byte_size = f.vim.get_buf_byte_size(buf)
                            if byte_size < vim.g.max_byte_size then
                                bufs[buf] = true
                            end
                        end
                        local prev_buf = vim.fn.bufnr("#")
                        if prev_buf == -1 then
                            return vim.tbl_keys(bufs)
                        end

                        local prev_buf_byte_size = f.vim.get_buf_byte_size(prev_buf)
                        if prev_buf_byte_size < vim.g.max_byte_size then
                            bufs[prev_buf] = true
                        end
                        return vim.tbl_keys(bufs)
                    end,
                    keyword_pattern = [[\k\+]],
                },
                keyword_length = 3
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
                            select = true,
                            behavior = cmp.ConfirmBehavior.Replace,
                        },
                        { "i", "c" }
                    )
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
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
                    { name = "cmdline" },
                    { name = "path" }
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
    }
}
