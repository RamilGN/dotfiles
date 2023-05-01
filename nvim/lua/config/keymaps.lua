return {
    setup = function()
        local wk = require("which-key")

        local keymaps = {
            -- Fast shortucts
            ["<C-1>"] = {
                { "<Cmd>ToggleTermSendCurrentLineNoTW 1<CR>", "Send line to term 1" },
                { ":ToggleTermSendVisualSelectionNoTW 1<CR>", "Send visual selection to term 1", mode = "v" },
            },
            ["<C-2>"] = {
                { "<Cmd>ToggleTermSendCurrentLineNoTW 2<CR>", "Send line to term 2" },
                { ":ToggleTermSendVisualSelectionNoTW 2<CR>", "Send visual selection to term 2", mode = "v" }
            },
            ["<C-[>"] = { "<C-\\><C-n>", "Normal mode", mode = "t" },
            ["<C-k>"] = { "<C-w><Up>", "Go to upper window" },
            ["<C-j>"] = {
                { "<C-w><down>", "Go to bottom window" },
                { "<C-^>",       "Switch layout",      mode = { "i", "c", "t" } }
            },
            ["<C-l>"] = { "<C-w><right>", "Go to right window" },
            ["<C-h>"] = { "<C-w><Left>", "Go to left window" },
            ["<C-Up>"] = { "<Cmd>resize -2<CR>", "Resize horiz-" },
            ["<C-Down>"] = { "<Cmd>resize +2<CR>", "Resize horiz+" },
            ["<C-Left>"] = { "<Cmd>vertical resize -2<CR>", "Resize vert-" },
            ["<C-Right>"] = { "<Cmd>vertical resize +2<CR>", "Resize vert+" },
            ["<C-w>"] = {
                name = "+window",
                ["b"] = { ":bd! %<CR>", "Close current buffer" },
            },
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
                    ["1"] = { "<Cmd>1ToggleTerm direction=float<CR>", "Toggle term1" },
                    ["2"] = { "<Cmd>2ToggleTerm direction=vertical<CR>", "Toggle term2" },
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
