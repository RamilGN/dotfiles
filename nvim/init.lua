-----------------------------------------------------------
-- # General settings
-----------------------------------------------------------

-- ## Russian keyboard layout
vim.opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
-- ## Line numbers
vim.opt.number = true
-- ## Use interactive zsh
vim.opt.shell = 'zsh -i'
-- ## Show some lines after cursor
vim.opt.scrolloff = 5
-- ## Location of new vertical split
vim.opt.splitright = true
-- ## Autocomplete
vim.opt.completeopt = 'menuone,noselect'
-- ## Ignore case if there are no capital letters in the search string
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- ## Undo after rebooting
vim.opt.undofile = true
-- ## Term colors
vim.opt.termguicolors = true
-- ## Highlight current line
vim.opt.cursorline = true
-- ## Decrease update time
vim.opt.updatetime = 250
-- ## Sign clolum
vim.opt.signcolumn = 'yes'
-- ## Highlight yanking text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-----------------------------------------------------------
-- # General shortcuts
-----------------------------------------------------------

-- ## Russian layout commnad mode
vim.keymap.set('n', 'Ж', ':')
-- ## Word wrapping
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'л', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'о', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- ## Space as <leader>
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- ## Move between windows
vim.keymap.set('n', '<C-k>', '<C-w><up>')
vim.keymap.set('n', '<C-j>', '<C-w><down>')
vim.keymap.set('n', '<C-l>', '<C-w><right>')
vim.keymap.set('n', '<C-h>', '<C-w><Left>')
-- ## Turn off highlight after search
vim.keymap.set('n', '//', ':nohlsearch<CR>')
-- ## Add spaces below/under cursor
vim.keymap.set('n', '[<leader>', 'm`o<Esc>``')
vim.keymap.set('n', ']<leader>', 'm`O<Esc>``')
-- ## Edit/source current config
vim.keymap.set('n', '<leader>vl', ':vsp $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>vs', ':source $MYVIMRC<CR>')
-- ## Repeat last command
vim.keymap.set('n', '<leader>re', '@:')
-- ## Yank/Paste system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')

-----------------------------------------------------------
-- # Plugins
-----------------------------------------------------------

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  ----------------------------
  -- ## UI
  ----------------------------

  -- ### Theme
  use 'EdenEast/nightfox.nvim'
  vim.cmd('colorscheme nightfox')

  -- ### Fancy lower statusline
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  require('lualine').setup {
    options = {
      component_separators = '|',
      section_separators = '',
    }
  }

  -- ### Displaying indents
  use 'lukas-reineke/indent-blankline.nvim'
  require('indent_blankline').setup {
    char = '┊',
  }

  ----------------------------
  -- ## Git
  ----------------------------

  -- ### Decorations
  use 'lewis6991/gitsigns.nvim'
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }
  vim.keymap.set('n', '<leader>gd', '<Cmd>Gitsigns diffthis<CR>')
  vim.keymap.set('n', '<leader>gh', '<Cmd>Gitsigns preview_hunk<CR>')
  vim.keymap.set('n', '<leader>gr', '<Cmd>Gitsigns reset_hunk<CR>')
  vim.keymap.set('n', '<leader>gn', '<Cmd>Gitsigns next_hunk<CR>')
  vim.keymap.set('n', '<leader>gN', '<Cmd>Gitsigns prev_hunk<CR>')

  ----------------------------
  -- ## Telescope
  ----------------------------

  -- Fuzzy finder over lists with fzf extension
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  require('telescope').setup()
  require('telescope').load_extension('fzf')
  vim.keymap.set('n', '<leader>b', '<Cmd>Telescope buffers<CR>')
  vim.keymap.set('n', '<leader>tb', '<Cmd>Telescope current_buffer_fuzzy_find<CR>')
  vim.keymap.set('n', '<leader>tf', '<Cmd>Telescope find_files<CR>')
  vim.keymap.set('n', '<leader>tl', '<Cmd>Telescope live_grep<CR>')
  vim.keymap.set('n', '<leader>ts', '<Cmd>Telescope grep_string<CR>')
  vim.keymap.set('n', '<leader>td', '<Cmd>Telescope diagnostics<CR>')
  vim.keymap.set('n', '<leader>tg', '<Cmd>Telescope git_commits<CR>')
  vim.keymap.set('n', '<leader>tr', '<Cmd>Telescope lsp_references<CR>')
  vim.keymap.set('n', '<leader>to', '<Cmd>Telescope lsp_document_symbols<CR>')
  vim.keymap.set('n', '<leader>tw', '<Cmd>Telescope lsp_workspace_symbols<CR>')
  vim.keymap.set('n', '<leader>th', '<Cmd>Telescope help_tags<CR>')
  -- require'telescope.builtin'.grep_string{ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } -- TODO

  ----------------------------
  -- ## Treesitter -- TODO
  ----------------------------

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects', requires = { 'nvim-treesitter/nvim-treesitter' } }
  use { 'andymass/vim-matchup', requires = { 'nvim-treesitter/nvim-treesitter' } }
  require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      }
    },
    indent = {
      enable = true,
      disable = { 'ruby' }
    },
    -- TODO
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        }
      }
    },
    matchup = {
      enable = true
    }
  }
  -- TODO: WHEREAMI

  ----------------------------
  -- ## LSP
  ----------------------------

  use 'williamboman/nvim-lsp-installer'
  use 'neovim/nvim-lspconfig'
  require('nvim-lsp-installer').setup {
    automatic_installation = true
  }

  -- Diagnositc mappings
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

  -- General LSP setting
  local on_attach = function(client, bufnr)
    -- Mappings
    local bufopts = { buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, bufopts)
  end

  local lspconfig = require('lspconfig')
  local servers = { 'sumneko_lua', 'solargraph' }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach
    }
  end

  ----------------------------
  -- ## Other
  ----------------------------

  -- ### Autopairs
  use 'windwp/nvim-autopairs'
  require('nvim-autopairs').setup()

  -- ### Text editing
  use 'tpope/vim-repeat' -- TODO
  use 'tpope/vim-surround' -- TODO

  -- ### Autosaving
  use 'Pocco81/AutoSave.nvim'
  require('autosave').setup {
    execution_message = ''
  }

  -- ### Popup with suggestions to complete a key binding
  use 'folke/which-key.nvim' -- Popup with suggestions to complete a key binding
  require('which-key').setup()

  -- ### Hightlight trailing whitespaces
  use 'ntpeters/vim-better-whitespace'
  vim.g.better_whitespace_enabled = true
  vim.g.better_whitespace_ctermcolor = 'DarkRed'
  vim.g.better_whitespace_guicolor = 'DarkRed'

  -- ### Indentation style detection
  use 'nmac427/guess-indent.nvim'
  require('guess-indent').setup()

  -- ### Comment lines with shortcuts
  use 'numToStr/Comment.nvim' -- Comment lines with shortcuts
  require('Comment').setup()

  -- ### File explorer
  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } } -- File explorer
  require('nvim-tree').setup()
  vim.keymap.set('n', '<leader><leader>', ':NvimTreeFindFileToggle<CR>')
end)

-----------------------------------------------------------
-- TODO
-----------------------------------------------------------

-- 1) Repeat last shortcut map

-- 2) Implement automatic switch to `en` layout when entering command mode

-- 3) Endwise

-- vim: ts=2 sts=2 sw=2 et
