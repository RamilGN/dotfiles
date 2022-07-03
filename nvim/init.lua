-----------------------------------------------------------
-- Package manager
-----------------------------------------------------------

-- Plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  -- UI
  use 'EdenEast/nightfox.nvim' -- Theme
  use { 'nvim-lualine/lualine.nvim',  requires = { 'kyazdani42/nvim-web-devicons', opt = true  } } -- Lower statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Displaying indents
  -- Git
  use 'lewis6991/gitsigns.nvim' -- Git decorations
  -- Other
  use 'Pocco81/AutoSave.nvim' -- Autosaving
  use 'folke/which-key.nvim' -- Popup with suggestions to complete a key binding
  use 'ntpeters/vim-better-whitespace' -- Highlight whitespaces
  use 'nmac427/guess-indent.nvim' -- Indentation style detection
  use 'numToStr/Comment.nvim' -- Comment lines with shortcuts
  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } } -- File explorer
end)

-----------------------------------------------------------
-- General settings
-----------------------------------------------------------

-- Russian keyboard layout
vim.opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
-- Line numbers
vim.opt.number = true
-- Show some lines after cursor
vim.opt.scrolloff = 5
-- Location of new vertical split
vim.opt.splitright = true
-- Autocomplete
vim.opt.completeopt = 'menuone,noselect'
-- Ignore case if there are no capital letters in the search string
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Undo after rebooting
vim.opt.undofile = true
-- Term colors
vim.opt.termguicolors = true
-- Highlight current line
vim.opt.cursorline = true
-- Decrease update time
vim.opt.updatetime = 250
-- Sign clolum
vim.opt.signcolumn = 'yes'
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
vim.keymap.set('n', '<C-k>', '<C-w><up>')
vim.keymap.set('n', '<C-j>', '<C-w><down>')
vim.keymap.set('n', '<C-l>', '<C-w><right>')
vim.keymap.set('n', '<C-h>', '<C-w><Left>')
-- Turn off highlight after search
vim.keymap.set('n', '//', ':nohlsearch<CR>')
-- Edit/source current config
vim.keymap.set('n', '<leader>vl', ':vsp $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>vs', ':source $MYVIMRC<CR>')
-- Repeat last command
vim.keymap.set('n', '<leader>re', '@:')
-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- packer - package manager
-- Use command `:PackerSync` after changing any plugin configuration

----------------------------
-- UI
----------------------------

-- nightfox - theme
vim.cmd('colorscheme nightfox')

-- lualine - lower statusline
require('lualine').setup()

-- indent_blankline - displaying indents
require('indent_blankline').setup {
  char = '┊',
}

----------------------------
-- Git
----------------------------

-- gitsigns - git decorations
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
vim.keymap.set('n', '<leader>gd', ':Gitsigns diffthis<CR>')
vim.keymap.set('n', '<leader>gh', ':Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>gn', ':Gitsigns next_hunk<CR>')
vim.keymap.set('n', '<leader>gN', ':Gitsigns prev_hunk<CR>')

----------------------------
-- Other
----------------------------

-- autosave
require('autosave').setup {
  execution_message = ''
}

-- whichkey - popup with suggestions to complete a key binding
require('which-key').setup()

-- vim-better-whitespace - hightlight trailing whitespaces
vim.g.better_whitespace_enabled = true
vim.g.better_whitespace_ctermcolor = 'DarkRed'
vim.g.better_whitespace_guicolor = 'DarkRed'

-- Comment - comment lines with shortcuts
require('Comment').setup()

-- nvim-tree - file explorer
require('nvim-tree').setup()
vim.keymap.set('n', '<leader><leader>', ':NvimTreeFindFileToggle<CR>')

-----------------------------------------------------------
-- TODO
-----------------------------------------------------------

-- 1) Repeat last shortcut map

-- 2) Implement automatic switch to `en` layout when entering command mode

-- vim: ts=2 sts=2 sw=2 et
