-----------------------------------------------------------
-- # Settings
-----------------------------------------------------------

-- ## Russian keyboard layout
vim.opt.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
-- ## Line numbers
vim.opt.number = true
-- ## Show some lines after cursor
vim.opt.scrolloff = 5
-- ## Location of new vertical split
vim.opt.splitright = true
-- ## Autocomplete
vim.opt.completeopt = 'menu,menuone,noselect'
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
vim.opt.signcolumn = 'auto:2'
-- Foldings
vim.o.foldenable = false
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
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
-- # Mappinngs
-----------------------------------------------------------

-- ## Russian layout command mode
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
-- ## Exit terminal mode
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>')
-- ## Close current buffer
vim.keymap.set('n', '<C-w>b', ':bd! %<CR>')
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
-- # Commands
-----------------------------------------------------------

-- ## Git

-- ### Git log current file
vim.cmd('command! -nargs=0 Glog vsplit term://git --no-pager log -p --stat --follow %')
-- ### Git log current file with range
vim.cmd('command! -nargs=1 Glogr vsplit term://git --no-pager log -p -L <args>:%')

-----------------------------------------------------------
-- # Helpers
-----------------------------------------------------------

function vim.get_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

-----------------------------------------------------------
-- # Plugins
-----------------------------------------------------------

require('packer').startup({
  function(use)
    use { 'wbthomason/packer.nvim' }

    -----------------------------------------------------------
    -- ## UI
    -----------------------------------------------------------

    -- ### Theme
    use {
      'EdenEast/nightfox.nvim',
      config = function()
        vim.cmd('colorscheme nightfox')
      end
    }

    -- ### Fancy lower statusline
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require('lualine').setup {
          options = {
            component_separators = '|',
            section_separators = '',
          }
        }
      end
    }

    -- ### Displaying indents
    use {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('indent_blankline').setup {
          char = '┊',
          show_current_context = true,
        }
      end
    }

    -----------------------------------------------------------
    -- ## Git
    -----------------------------------------------------------

    -- ## Git decorations and buffer integration
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup {
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
        }

        -- ## Mappings
        vim.keymap.set('n', '<leader>gd', '<Cmd>Gitsigns diffthis<CR>')
        vim.keymap.set('n', '<leader>gh', '<Cmd>Gitsigns preview_hunk<CR>')
        vim.keymap.set('n', '<leader>gr', '<Cmd>Gitsigns reset_hunk<CR>')
        vim.keymap.set('n', ']g', '<Cmd>Gitsigns next_hunk<CR>')
        vim.keymap.set('n', '[g', '<Cmd>Gitsigns prev_hunk<CR>')
      end
    }

    -----------------------------------------------------------
    -- ## Telescope
    -----------------------------------------------------------

    -- ### Fuzzy finder over lists
    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        -- ### Settings
        local telescope = require('telescope')
        telescope.setup {
          pickers = {
            buffers = {
              sorting_strategy = 'ascending',
              ignore_current_buffer = true,
              sort_mru = true,
              theme = 'dropdown',
              previewer = false,
              mappings = {
                i = {
                  ['<C-d>'] = 'delete_buffer',
                }
              }
            }
          }
        }
        local t = require('telescope.builtin')

        -- ### Mappings
        vim.keymap.set('n', '<leader>b', '<Cmd>Telescope buffers<CR>')
        vim.keymap.set('n', '<leader>tp', '<Cmd>Telescope resume<CR>')
        vim.keymap.set('n', '<leader>tf', '<Cmd>Telescope find_files<CR>')
        vim.keymap.set('n', '<leader>tg', '<Cmd>Telescope git_commits<CR>')
        vim.keymap.set('n', '<leader>th', '<Cmd>Telescope help_tags<CR>')

        vim.keymap.set('n', '<leader>td', '<Cmd>Telescope diagnostics<CR>')
        vim.keymap.set('n', '<leader>to', '<Cmd>Telescope lsp_document_symbols<CR>')
        vim.keymap.set('n', '<leader>tw', '<Cmd>Telescope lsp_workspace_symbols<CR>')
        vim.keymap.set('n', '<leader>tr', '<Cmd>Telescope lsp_references<CR>')

        vim.keymap.set('n', '<leader>tl', '<Cmd>Telescope live_grep<CR>')
        vim.keymap.set('v', '<leader>tl', function()
          local text = vim.get_visual_selection()
          t.live_grep({ default_text = text })
        end)

        vim.keymap.set('n', '<leader>tb', '<Cmd>Telescope current_buffer_fuzzy_find<CR>')
        vim.keymap.set('v', '<leader>tb', function()
          local text = vim.get_visual_selection()
          t.current_buffer_fuzzy_find({ default_text = text })
        end)

        vim.keymap.set('n', '<leader>ts', '<Cmd>Telescope grep_string<CR>')
        vim.keymap.set('v', '<leader>ts', function()
          local text = vim.get_visual_selection()
          t.grep_string({ default_text = text })
        end)
      end
    }

    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      requires = { 'nvim-telescope/telescope.nvim' },
      config = function()
        require('telescope').load_extension('fzf')
      end
    }

    -----------------------------------------------------------
    -- ## Treesitter
    -----------------------------------------------------------

    use {
      'nvim-treesitter/nvim-treesitter-context',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('treesitter-context').setup({
          patterns = {
            default = {
              'class',
              'function',
              'method',
              'for',
              'while',
              'if',
              'else',
              'switch',
              'case',
            },
            javascript = {
              'object',
              'pair',
            },
            ruby = {
              'module',
              'block'
            },
            yaml = {
              'block_mapping_pair',
              'block_sequence_item',
            },
            json = {
              'object',
              'pair',
            },
          },
        })
      end
    }

    use { 'nvim-treesitter/nvim-treesitter-textobjects', requires = { 'nvim-treesitter/nvim-treesitter' } }

    use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
      end,
      config = function()
        require('nvim-treesitter.configs').setup {
          auto_install = true,
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
            disable = true,
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ['af'] = '@function.outer', ['if'] = '@function.inner', ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              }
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                [']f'] = '@function.outer',
                [']c'] = '@class.outer',
              },
              goto_next_end = {
                [']F'] = '@function.outer',
                [']C'] = '@class.outer',
              },
              goto_previous_start = {
                ['[f'] = '@function.outer',
                ['[c'] = '@class.outer',
              },
              goto_previous_end = {
                ['[F'] = '@function.outer',
                ['[C'] = '@class.outer',
              },
            }
          }
        }
      end
    }

    -----------------------------------------------------------
    -- ## LSP
    -----------------------------------------------------------

    -- Prepare sources and snippet engine for autocompletion
    use {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      requires = { 'hrsh7th/nvim-cmp' }
    }

    -- ### Autocompletion
    use {
      'hrsh7th/nvim-cmp',
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          -- ### Mappings
          mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-2),
            ['<C-f>'] = cmp.mapping.scroll_docs(2),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true
            }
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            {
              name = 'buffer',
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end
              }
            },
            { name = 'path' },
          }
        }

        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources {
            { name = 'path' },
            { name = 'cmdline' }
          }
        })
      end
    }

    -- ### LSP config and installer
    use {
      'williamboman/nvim-lsp-installer',
      {
        'neovim/nvim-lspconfig',
        config = function()
          lsp_installer = require('nvim-lsp-installer').setup {
            automatic_installation = true,
            ui = {
              icons = {
                server_installed = '✓',
                server_pending = '➜',
                server_uninstalled = '✗'
              }
            }
          }

          -- ### Diagnositc mappings
          local opts = { noremap = true, silent = true }
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

          -- ### Mappings
          local on_attach = function(_, bufnr)
            local bufopts = { buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<leader>ff', function()
              vim.lsp.buf.format({ async = true })
            end, bufopts)
          end

          -- ### Autocompletion capabilities
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

          -- ### LSP servers
          local lspconfig = require('lspconfig')
          local servers = { 'sumneko_lua', 'solargraph', 'gopls' }
          -- local servers = { lsp_installer.get_installed_servers() }
          for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup {
              on_attach = on_attach,
              capabilities = capabilities
            }
          end
        end
      }
    }

    -----------------------------------------------------------
    -- ## Other
    -----------------------------------------------------------

    -- ### Autopairs
    use {
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end
    }

    -- ### Autosaving
    use {
      'Pocco81/AutoSave.nvim',
      config = function()
        require('autosave').setup {
          execution_message = ''
        }
      end
    }

    -- ### Popup with suggestions to complete a key binding
    use {
      'folke/which-key.nvim',
      config = {
        function()
          require('which-key').setup()
        end
      }
    }

    -- ### Hightlight trailing whitespaces
    use {
      'ntpeters/vim-better-whitespace',
      config = function()
        vim.g.better_whitespace_enabled = true
        vim.g.better_whitespace_ctermcolor = 'DarkRed'
        vim.g.better_whitespace_guicolor = 'DarkRed'
      end
    }

    -- ### Indentation style detection
    use {
      'nmac427/guess-indent.nvim',
      config = function()
        require('guess-indent').setup()
      end
    }

    -- ### Comment lines with shortcuts
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }

    -- ### File explorer
    use {
      'kyazdani42/nvim-tree.lua',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup()
        vim.keymap.set('n', '<leader><leader>', ':NvimTreeToggle<CR>')
        vim.keymap.set('n', '<C-n>', ':NvimTreeFindFile<CR>')
      end
    }

    -- ### Text editing
    use { 'tpope/vim-repeat' } -- TODO
    use { 'tpope/vim-surround' } -- TODO

    -----------------------------------------------------------
    -- ## Language specific plugins
    -----------------------------------------------------------

    -- ### Ruby
    use { 'slim-template/vim-slim' }
  end,
  config = {
    enable = true,
    display = {
      open_fn = require('packer.util').float,
      log = { level = 'warn' },
    }
  }
})

-----------------------------------------------------------
-- TODO
-----------------------------------------------------------

-- 1) Implement automatic switch to `en` layout when entering command mode

-- 2) vim.call('repeat#set', ']d')

-- 3) Schema store

-- 4) Text editig vim-repeat, vim-surround

-- 5) LSP servers yaml, json

-- 6) Vim repeat, surrond

-- vim: ts=2 sts=2 sw=2 et
