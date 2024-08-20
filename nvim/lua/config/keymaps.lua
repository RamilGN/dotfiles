local UtilBuf = function()
    return require("myplugins.util.buf")
end

return {
    core = function()
        local map = vim.keymap.set
        -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
        map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
        map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
        map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
        map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
        map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
        map("n", "ZA", "<Cmd>wqall!<CR>", { desc = "Force quit all" })
        -- Package manager.
        map("n", "<leader>pp", "<Cmd>Lazy home<CR>", { desc = "Plugins" })
        -- Search without jumping.
        map("n", "#", function()
            local text = vim.fn.expand("<cword>")
            vim.fn.setreg("/", text)
            vim.cmd("set hls")
        end, { desc = "Search word without jumping", silent = true })
        -- Turn off highlight.
        map("n", "//", ":nohlsearch<CR>", { desc = "Turn off highlight" })
        -- Better up/down.
        map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Up with line wrap", expr = true, silent = true })
        map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Down with line wrap", expr = true, silent = true })
        map({ "i", "c" }, "<C-h>", "<Left>", { desc = "Go to left window" })
        map({ "i", "c" }, "<C-l>", "<Right>", { desc = "Go to right window" })
        map("n", "<C-h>", "<C-w><Left>", { desc = "Go to left window" })
        -- Better start/end
        map({ "n", "v" }, ")", "$", { desc = "To the end line" })
        map({ "n", "v" }, "(", "^", { desc = "To the start of line" })
        -- Move Lines
        map("n", "<A-j>", "<Cmd>m .+1<CR>==", { desc = "Move down" })
        map("n", "<A-k>", "<Cmd>m .-2<CR>==", { desc = "Move up" })
        map("i", "<A-j>", "<Esc><Cmd>m .+1<CR>==gi", { desc = "Move down" })
        map("i", "<A-k>", "<Esc><Cmd>m .-2<CR>==gi", { desc = "Move up" })
        map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
        map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
        -- Better scroll.
        map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with center" })
        map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
        -- Better indent.
        map("v", "<", "<gv")
        map("v", ">", ">gv")
        -- Follow line number with `gf`.
        map({ "n", "v" }, "gf", "gF")
        map({ "n", "v" }, "gF", "gf")
        -- New lines.
        map("n", "<CR>", "m`o<Esc>``", { desc = "Insert new line below cursor" })
        map("n", "<S-CR>", "m`O<Esc>``", { desc = "Insert new line under cursor" })
        -- Close buffer.
        map("n", "<C-w>b", ":bd! %<CR>", { desc = "Close current buffer" })
        map("n", "<C-w>t", "<Cmd>tabc<CR>", { desc = "Close current tab" })
        -- Without yank.
        map("v", "p", [["_dP]], { desc = "Replace without yanking" })
        map({ "n", "v" }, "c", [["_c]], { desc = "Change without yanking" })
        map({ "n", "v" }, "C", [["_C]], { desc = "Change without yanking" })
        -- Windows.
        map("n", "<C-k>", "<C-w><Up>", { desc = "Go to upper window" })
        map("n", "<C-j>", "<C-w><down>", { desc = "Go to bottom window" })
        map("n", "<C-l>", "<C-w><right>", { desc = "Go to right window" })
        map("n", "<C-h>", "<C-w><Left>", { desc = "Go to left window" })
        map("n", "<C-Up>", "<Cmd>resize -2<CR>", { desc = "Resize horiz-" })
        map("n", "<C-Down>", "<Cmd>resize +2<CR>", { desc = "Resize horiz+" })
        map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Resize vert-" })
        map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Resize vert+" })
        -- Set options and misc.
        map("n", "yos", "<Cmd>setlocal invspell<CR>", { desc = "Set spelling" })
        map("n", "yoc", "<Cmd>SetColorColumn<CR>", { desc = "Set vert limit bar" })
        map("n", "yol", "<Cmd>set invrelativenumber<CR>", { desc = "Toggle relative number" })
        map("n", "yof", UtilBuf().copy_rel_path_to_buffer, { desc = "Yank file path" })
        map("n", "yoF", UtilBuf().copy_rel_path_line_to_buffer, { desc = "Yank file path with line" })
        -- Prev action.
        map("n", "[b", ":bprev<CR>", { desc = "Prev buffer" })
        map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
        -- Diagnostic
        map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
        -- Spacing.
        map("n", "]<leader>", "<Cmd>norm i <CR>l", { desc = "Next buffer" })
        map("n", "[<leader>", "<Cmd>norm x <CR>hvp", { desc = "Next tab" })
        -- Mind.
        map("n", "<leader>mt", "<Cmd>e ~/mind/todo/current.md<CR>", { desc = "Open todo in mind" })
        map("n", "<leader>mf", "<Cmd>Telescope find_files cwd=~/mind<CR>", { desc = "Find files in mind" })
        map("n", "<leader>ms", "<Cmd>Telescope live_grep cwd=~/mind<CR>", { desc = "Live grep in mind" })
    end,
}
