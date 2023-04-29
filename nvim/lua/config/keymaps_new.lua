return {
    luasnip          = function()
        return {
            {
                "<C-f>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            { "<C-f>", function() require("luasnip").jump(1) end,  mode = "s" },
            { "<C-d>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        }
    end,
    mini             = {
        surround = function()
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            return {
                { opts.mappings.add,            desc = "Add surrounding",        mode = { "n", "v" } },
                { opts.mappings.delete,         desc = "Delete surrounding" },
                { opts.mappings.replace,        desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `coverage lines`" },
            }
        end
    },
    spectre          = function()
        return {
            { "<leader>s", function() require("spectre").open() end,             desc = "Search and replace" },
            { "<leader>S", function() require("spectre").open_file_search() end, desc = "Search and replace current file" },
        }
    end,
    markdown_preview = function()
        return {
            { "<leader>om", "<Cmd>MarkdownPreviewToggle<CR>", desc = "Toggle markdown preview" },
        }
    end,
    undotree         = function()
        return {
            { "<leader>ou", "<Cmd>UndotreeToggle<CR>", desc = "Undo tree" },
        }
    end,
    git              = function(buffer)
        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        local gs = package.loaded.gitsigns
        local tsrm = require "nvim-treesitter.textobjects.repeatable_move"
        local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

        map("n", "]g", next_hunk_repeat, "Next Hunk")
        map("n", "[g", prev_hunk_repeat, "Prev Hunk")
        map("n", "<leader>gy", function() require("gitlinker").get_buf_range_url("n") end, "Git copy link")
        map("v", "<leader>gy", function() require("gitlinker").get_buf_range_url("v") end, "Git copy link")
    end,
    neotree          = function()
        return {
            { "<C-Space>", "<Cmd>Neotree position=current reveal=true toggle=true<CR>", desc = "Open file explorer" }
        }
    end
}
