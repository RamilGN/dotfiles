return {
    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        keys = {
            {
                "<C-f>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            {
                "<C-f>",
                function()
                    require("luasnip").jump(1)
                end,
                mode = { "s" },
            },
            {
                "<C-d>",
                function()
                    require("luasnip").jump(-1)
                end,
                mode = { "i", "s" },
            },
            {
                "<BS>",
                function()
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Del>", true, true, true), "x")
                    require("luasnip").jump(1)
                end,
                mode = { "s" },
            },
        },
        config = function(_, opts)
            require("luasnip").config.set_config(opts)
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "saadparwaiz1/cmp_luasnip" },
        },
        config = function()
            local buf = require("myplugins.util.buf")
            local cmp = require("cmp")

            local lsp_source = { name = "nvim_lsp" }

            local luasnip_source = { name = "luasnip" }

            local buffer_source = {
                name = "buffer",
                option = {
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local wbuf = vim.api.nvim_win_get_buf(win)
                            local byte_size = buf.get_buf_byte_size(wbuf)
                            if byte_size < vim.g.max_byte_size then
                                bufs[wbuf] = true
                            end
                        end
                        local prev_buf = vim.fn.bufnr(0)
                        if prev_buf == -1 then
                            return vim.tbl_keys(bufs)
                        end

                        local prev_buf_byte_size = buf.get_buf_byte_size(prev_buf)
                        if prev_buf_byte_size < vim.g.max_byte_size then
                            bufs[prev_buf] = true
                        end
                        return vim.tbl_keys(bufs)
                    end,
                    keyword_pattern = [[\k\+]],
                },
                keyword_length = 2,
            }

            local path_source = { name = "path" }

            local function border(hl_name)
                return {
                    { "╭", hl_name },
                    { "─", hl_name },
                    { "╮", hl_name },
                    { "│", hl_name },
                    { "╯", hl_name },
                    { "─", hl_name },
                    { "╰", hl_name },
                    { "│", hl_name },
                }
            end

            cmp.setup({
                window = {
                    completion = {
                        side_padding = 0,
                        completeopt = "menu,menuone,noinsert",
                        winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
                        border = border("CmpDocBorder"),
                    },
                    documentation = {
                        border = border("CmpDocBorder"),
                        winhighlight = "Normal:CmpDoc",
                        scrollbar = false,
                    },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-2),
                    ["<C-d>"] = cmp.mapping.scroll_docs(2),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    ["<S-CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    lsp_source,
                    luasnip_source,
                    buffer_source,
                    path_source,
                },
                formatting = {
                    format = require("lspkind").cmp_format({}),
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "cmdline" },
                    { name = "path" },
                }),
            })

            for _, cmd_type in ipairs({ "/", "?" }) do
                cmp.setup.cmdline(cmd_type, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        buffer_source,
                    },
                })
            end
        end,
    },
}
