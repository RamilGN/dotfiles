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
    git              = {
        default = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- Git log
            map({ "n", "v" }, "<leader>gll", ":GitLog<CR>", "Git log")
            map("n", "<leader>glg", "<Cmd>GitLogG<CR>", "Git log global")

            -- Git show
            map("n", "<leader>gi", "<Cmd>GitShow<CR>", "Git show")
        end,
        signs = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            local gs = package.loaded.gitsigns
            local tsrm = require "nvim-treesitter.textobjects.repeatable_move"
            local next_hunk_repeat, prev_hunk_repeat = tsrm.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

            map("n", "]g", next_hunk_repeat, "Next Hunk")
            map("n", "[g", prev_hunk_repeat, "Prev Hunk")
            map("n", "<leader>gb", "<Cmd>Gitsigns blame_line<CR>", "Git blame_line")
            map("n", "<leader>gd", "<Cmd>Gitsigns diffthis<CR>", "Git diff")
            map("n", "<leader>gh", "<Cmd>Gitsigns preview_hunk<CR>", "Git preview hunk")
            map("n", "<leader>gv", "<Cmd>Gitsigns select_hunk<CR>", "Git select hunk")
            map("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
            map("n", "<leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", "Git reset buffer")
            map("n", "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk")
            map("n", "<leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", "Git stage buffer")
            map("n", "<leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "Git undo stage hunk")
        end,
        fugitive = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- Git menu
            map("n", "<leader>gg", "<Cmd>vert G<CR>", "Git")

            -- Git log
            map("n", "<leader>glo", "<Cmd>vert G log -n 1000<CR>", "Git log 1000")

            -- Git add/stage
            map("n", "<leader>gaa", "<Cmd>vert G add -v --patch<CR>", "Git add patch")

            -- Git commit
            map("n", "<leader>gcc", "<Cmd>vert G commit -v<CR>", "Git commit")
            map("n", "<leader>gca", "<Cmd>vert G commit -v --amend<CR>", "Git commit amend")
            map("n", "<leader>gcn", "<Cmd>vert G commit -v --amend --no-edit<CR>", "Git commit amend no-edit")

            -- Git push/pull
            map("n", "<leader>gpp", "<Cmd>G push -v<CR>", "Push")
            map("n", "<leader>gpf", "<Cmd>G push -v --force-with-lease<CR>", "Force push")
            map("n", "<leader>gpl", "<Cmd>G pull -v<CR>", "Git pull")
        end,
        linker = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            local gitlinker = require("gitlinker")

            map("n", "<leader>gy", function() gitlinker.get_buf_range_url("n") end, "Git copy link")
            map("v", "<leader>gy", function() gitlinker.get_buf_range_url("v") end, "Git copy link")
        end,
        telescope = function(buffer)
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            map("n", "<C-g>", "<Cmd>silent! Telescope git_status<CR>", "Git status")
            map("n", "<leader>gos", "<Cmd>Telescope git_stash<CR>", "Git stash")
            map("n", "<leader>goc", "<Cmd>Telescope git_commits<CR>", "Git commits")
            map("n", "<leader>goC", "<Cmd>Telescope git_bcommits<CR>", "Git commits")
            map("n", "<leader>gob", "<Cmd>Telescope git_branches<CR>", "Git branches")
        end
    },
    neotree          = function()
        return {
            { "<C-Space>", "<Cmd>Neotree position=current reveal=true toggle=true<CR>", desc = "Open file explorer" }
        }
    end
}
