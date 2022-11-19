-- ## Word wrapping
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- ## Space as <leader>
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- ## Move between windows
vim.keymap.set("n", "<C-k>", "<C-w><up>")
vim.keymap.set("n", "<C-j>", "<C-w><down>")
vim.keymap.set("n", "<C-l>", "<C-w><right>")
vim.keymap.set("n", "<C-h>", "<C-w><Left>")
-- ## Scrolling up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- ## Exit terminal mode
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>")
-- ## Close current buffer
vim.keymap.set("n", "<C-w>b", ":bd! %<CR>")
-- ## Turn off highlight after search
vim.keymap.set("n", "//", ":nohlsearch<CR>")
-- ## Add newline below/under cursor
vim.keymap.set("n", "<CR>", "m`o<Esc>``")
vim.keymap.set("n", "<S-CR>", "m`O<Esc>``")
-- ## Edit/source current config
vim.keymap.set("n", "<leader>vl", "<Cmd>vsp $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>vs", "<Cmd>source $MYVIMRC<CR>")
-- ## Repeat last command
vim.keymap.set("n", "<leader>re", "@:")
-- ## Quit all
vim.keymap.set("n", "ZA", "<Cmd>qa!<CR>")
-- ## Serach word without jumping
vim.keymap.set("n", "#", ":let @/= '\\<'.expand('<cword>').'\\>' | set hls <CR>", { silent = true })
-- ## Replace selected text without yanking
vim.keymap.set("v", "p", '"_dP')
-- ## Change without yanking
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("v", "c", '"_c')

vim.keymap.set("n", "C", '"_C')
vim.keymap.set("v", "C", '"_C')
-- ## Switch layout
vim.keymap.set({ "c", "i" }, "<C-j>", "<C-^>")
-- ## Create a new tab
vim.keymap.set("n", "<leader>ct", "<Cmd>$tabnew %<CR>")
-- # Set spelling
vim.keymap.set("n", "yos", "<Cmd>set invspell<CR>")
-- # Line textobject
vim.keymap.set("v", "al", ":normal 0v$h<CR>")
vim.keymap.set("o", "al", ":normal val<CR>")
vim.keymap.set("v", "il", ":normal ^vg_<CR>")
vim.keymap.set("o", "il", ":normal vil<CR>")
-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")
-- ## Spaces
vim.keymap.set("n", "[<leader>", "i<leader><Esc>")
vim.keymap.set("n", "]<leader>", "a<leader><Esc>")
-- ## Buffers
vim.keymap.set("n", "]b", "<Cmd>bnext<CR>")
vim.keymap.set("n", "[b", "<Cmd>bprevious<CR>")
-- ## Quickfix
vim.keymap.set("n", "]q", "<Cmd>cnext<CR>")
vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>")


vim.keymap.set("n", "<leader>gl", "<Cmd>GitLog<CR>")
vim.keymap.set("v", "<leader>gl", ":GitLog<CR>")
vim.keymap.set("n", "<leader>gi", "<Cmd>GitShow<CR>")

vim.keymap.set("n", "yoc", "<Cmd>SetColorColumn<CR>")
