return {
    setup = function()
        local wk = require("which-key")

        local keymaps = {
            ["yo"] = {
                name = "+setoption",
                ["s"] = { "<Cmd>setlocal invspell<CR>", "Set spelling" },
                ["c"] = { "<Cmd>SetColorColumn<CR>", "Set vert limit bar" }
            },
            ["["] = {
                name = "+prevaction",
                ["b"] = { "<C-^>", "Last buffer" },
                ["t"] = { "<Cmd>tabprevious<CR>", "Prev tab" },
                ["q"] = { "<Cmd>cprev<CR>", "Prev item in qf" },
            },
            ["]"] = {
                name = "+nextaction",
                ["b"] = { "<Cmd>bnext<CR>", "Next buffer" },
                ["t"] = { "<Cmd>tabnext<CR>", "Next tab" },
                ["q"] = { "<Cmd>cnext<CR>", "Next item in qf" },
            },
            ["il"] = {
                { ":normal ^vg_<CR>", "Line textobject", mode = "v" },
                { ":normal vil<CR>",  "Line textobject", mode = "o" }
            },
            ["al"] = {
                { ":normal 0v$h<CR>", "Line textobject", mode = "v" },
                { ":normal val<CR>",  "Line textobject", mode = "o" }
            },
            ["<leader>"] = {
                name = "+SPC",

                ["r"] = {
                    name = "+run",
                    ["u"] = { ":Run<CR>", "Run current file", mode = { "n", "v" } },
                    ["e"] = { function() vim.cmd(vim.g.last_command) end, "Last command" },
                    ["t"] = { function() vim.cmd("2TermExec direction=vertical cmd='" .. vim.g.last_cmd .. "'") end, "Last command in term" },
                    ["v"] = { "<Cmd>@:<CR>", "Last command no expand" },
                },

                ["l"] = {
                    name = "+lsp/action",
                    ["n"] = { ":Neogen<CR>", "Annotate" },
                    ["d"] = { vim.diagnostic.open_float, "Open diagnostic float window" },
                },

                ["o"] = {
                    name = "+open/toggle",
                    ["q"] = { "<Cmd>copen<CR>", "Open quick fix list" },
                    ["t"] = { "<Cmd>$tabnew %<CR>", "Open tab for current buffer" },
                },

                ["p"] = {
                    name = "+plugins/packages",
                    ["p"] = { "<Cmd>Lazy home<CR>", "Plugins" },
                    ["m"] = { "<Cmd>Mason<CR>", "Mason" },
                }
            }
        }

        wk.register(keymaps)
    end
}
