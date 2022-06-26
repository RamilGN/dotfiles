-----------------------------------------------------------
-- Package manager
-----------------------------------------------------------

-- Plugins 
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'EdenEast/nightfox.nvim' -- Theme
  use { 'nvim-lualine/lualine.nvim',  requires = { 'kyazdani42/nvim-web-devicons', opt = true } } -- Lower statusline 
  use 'lukas-reineke/indent-blankline.nvim' -- Displaying indents
end)

-----------------------------------------------------------
-- General settings
-----------------------------------------------------------

-- Russian keyboard layout
vim.opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
-- Line numbers
vim.opt.number = true
-- Autocomplete
vim.opt.completeopt = 'menu,menuone,noselect'
-- Ignore case if there are no capital letters in the search string
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Highlight search string
vim.opt.hlsearch = true
-- Undo after rebooting
vim.opt.undofile = true
-- Auto indent
vim.opt.autoindent = true
-- Term colors
vim.opt.termguicolors = true
-- Highlight current line 
vim.opt.cursorline = true
-- Decrease update time
vim.opt.updatetime = 250
-- Sign clolum 
vim.opt.signcolumn = 'yes'
-- Consider offset when searching
vim.opt.cpoptions = 'n'
-- Highlight yanking text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-----------------------------------------------------------
-- General shortcuts
-----------------------------------------------------------

-- Russian layout commnad mode
vim.keymap.set('n', 'Ж', ':')
-- Word wrapping
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'л', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'о', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Space as <leader>
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Move between windows 
vim.keymap.set('n', '<c-k>', '<c-w><up>')
vim.keymap.set('n', '<c-j>', '<c-w><down>')
vim.keymap.set('n', '<c-l>', '<c-w><right>')
vim.keymap.set('n', '<c-h>', '<C-w><Left>')
-- Turn off highlight after search 
vim.keymap.set('n', '//', ':nohlsearch<CR>')
-- Yank/paste from sytem cliboard
vim.keymap.set({ 'n', 'v' }, '"y', '"+y')
vim.keymap.set('n', '"Y', '"+Y')
vim.keymap.set('n', '"p', '"+p')
vim.keymap.set('n', '"P', '"+P')
-- Edit/source current config
vim.keymap.set('n', '<leader>vl', ':vsp $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>vs', ':source $MYVIMRC<CR>')

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- packer - package manager
-- Use command `:PackerSync` after changing any plugin configuration

-- nightfox - theme
vim.cmd('silent! colorscheme nightfox')

-- lualine - lower statusline 
require('lualine').setup()

-- indent_blankline - displaying indents
require('indent_blankline').setup {
  char = '┊',
}

-----------------------------------------------------------
-- TODO
-----------------------------------------------------------

-- Implement automatic switch to `en` layout when entering command mode

-- vim: ts=2 sts=2 sw=2 et
