-----------------------------------------------------------
-- # Settings
-----------------------------------------------------------

-- ## Russian keyboard layout
vim.opt.keymap = "russian-jcukenwin"
vim.opt.iminsert = 0
vim.opt.imsearch = -1
-- ## Spell dictionaries
vim.opt.spelllang = { "en_us", "ru" }
-- ## Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- ## Show some lines after cursor
vim.opt.scrolloff = 10
-- ## Location of new vertical split
vim.opt.splitright = true
vim.opt.splitbelow = true
-- ## Autocomplete
vim.opt.completeopt = "menu,menuone,noselect"
-- ## Ignore case if there are no capital letters in the search string
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- ## Undo after rebooting
vim.opt.undofile = true
-- ## Term colors
vim.opt.termguicolors = true
-- ## Highlight current line
vim.opt.cursorline = true
-- ## Faster auto-completion and etc
vim.opt.updatetime = 150
-- ## Sign clolum
vim.opt.signcolumn = "yes:2"
-- ## Foldings
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- ## Swap file off
vim.opt.swapfile = false
-- ## Show trailing whitespaces, tabs
vim.opt.list = true
vim.opt.listchars = { tab = "▸▸", trail = "•", nbsp = "␣", extends = "…" }
-- ## Global statusline
vim.opt.laststatus = 3
-- ## Autowrite
vim.opt.autowrite = true
vim.opt.clipboard = "unnamedplus"
-- ### Turn off diagnostics errors near line
vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
})
-- ## Set maximum number of items in the popup menu
vim.opt.pumheight = 10
-- ## Scrollback lines for terminal buffer
vim.opt.scrollback = 100000

-----------------------------------------------------------
-- # Mappinngs
-----------------------------------------------------------

-- ## Word wrapping
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- ## Space as <leader>
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- ## Move between windows
vim.keymap.set("n", "<C-k>", "<C-w><up>")
vim.keymap.set("n", "<C-j>", "<C-w><down>")
vim.keymap.set("n", "<C-l>", "<C-w><right>")
vim.keymap.set("n", "<C-h>", "<C-w><Left>")
-- ## Exit terminal mode
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>")
-- ## Close current buffer
vim.keymap.set("n", "<C-w>b", ":bd! %<CR>")
-- ## Turn off highlight after search
vim.keymap.set("n", "//", ":nohlsearch<CR>")
-- ## Add newline below/under cursor
vim.keymap.set("n", "<CR>", "m`o<Esc>``")
vim.keymap.set("n", "<S-CR>", "m`O<Esc>``")
-- ## Add spaces before/after cursor
vim.keymap.set("n", "[<leader>", "i<leader><Esc>")
vim.keymap.set("n", "]<leader>", "a<leader><Esc>")
-- ## Edit/source current config
vim.keymap.set("n", "<leader>vl", ":vsp $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>vs", ":source $MYVIMRC<CR>")
-- ## Repeat last command
vim.keymap.set("n", "<leader>re", "@:")
-- ## Serach word without jumping
vim.keymap.set("n", "#", ":let @/= '\\<'.expand('<cword>').'\\>' <bar> set hls <CR>", { silent = true })
-- ## Replace selected text without yanking
vim.keymap.set("v", "p", '"_dP')
-- ## Change without yanking
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_C')
-- ## Switch layout
vim.keymap.set("i", "<C-j>", "<C-^>")
-- ## Create a new tab
vim.keymap.set("n", "<leader>ct", ":$tabnew %<CR>")
-- # Set spelling
vim.keymap.set("n", "yos", ":set invspell<CR>")

-----------------------------------------------------------
-- # Commands
-----------------------------------------------------------

-- ## Git

-- ### Git log current file with range(optional)
vim.api.nvim_create_user_command(
  "GitLog",
  function(opts)
    local range = opts.args
    if range == "" then
      vim.cmd([[vsplit term://git --no-pager log -p --stat --follow ]] .. [[%]])
    else
      vim.cmd([[vsplit term://git --no-pager log -p -L]] .. range .. [[:%]])
    end
  end,
  { nargs = "?" }
)

-- ## Ruby

-- ### Rails

-- #### Routes

vim.api.nvim_create_user_command(
  "RailsRoutes",
  function(opts)
    local controller_name = opts.args
    if controller_name == "" then
      vim.cmd([[vsplit term://bundle exec bin/rails routes -E]])
    else
      vim.cmd([[vsplit term://bundle exec bin/rails routes -E -c=]] .. controller_name)
    end
  end,
  { nargs = "?" }
)

-- ### Other

-- ## Trim trailing whitespaces
vim.api.nvim_create_user_command(
  "TrimWhitespaces", function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.api.nvim_win_set_cursor(0, curpos)
  end, { nargs = 0 })

-- ## Set color bar
vim.api.nvim_create_user_command(
  "SetColorColumn", function()
    local current = vim.api.nvim_win_get_option(0, "colorcolumn")
    local cval = current == "" and "120" or ""
    vim.opt.colorcolumn = cval
  end, { nargs = "?", range = true })
-- ### Mappings
vim.keymap.set("n", "yoc", ":SetColorColumn<CR>")

-----------------------------------------------------------
-- # Autocommands
-----------------------------------------------------------

-- ## Highlight yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end
})

-- ## Turn off comments auto-insert
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end
})

-- Turn off input method outside insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.iminsert = 0
  end
})

-----------------------------------------------------------
-- # Helpers
-----------------------------------------------------------

function vim.get_visual_selection()
  vim.cmd([[noau normal! "vy"]])
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-----------------------------------------------------------
-- # Plugins
-----------------------------------------------------------

require("packer").startup({
  function(use)
    use({ "wbthomason/packer.nvim" })

    -----------------------------------------------------------
    -- ## UI
    -----------------------------------------------------------

    -- ### Icons
    use({
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup()
      end
    })

    -- ### Theme
    use({
      "catppuccin/nvim",
      config = function()
        require("catppuccin").setup()
        vim.g.catppuccin_flavour = "macchiato"
        vim.cmd([[silent! colorscheme catppuccin]])
      end
    })

    -- ### Fancy lower statusline
    use({
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
      config = function()
        require("lualine").setup({
          options = {
            theme = "nightfly",
            component_separators = {},
            section_separators = {}
          },
          sections = {
            lualine_c = { "%f" },
            lualine_z = { "%l:%v" }
          },
          extensions = { "nvim-tree" }
        })
      end
    })

    -- ### Tabline
    use {
      "alvarosevilla95/luatab.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("luatab").setup {
          modified = function()
            return ""
          end,
          windowCount = function(index)
            return "[" .. index .. "]" .. " "
          end,
          devicon = function()
            return ""
          end
        }
      end
    }

    -- ### Displaying indents
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup({
          char = "┊",
          show_trailing_blankline_indent = false
        })
      end
    })

    -----------------------------------------------------------
    -- ## Git
    -----------------------------------------------------------

    -- ## Git decorations and buffer integration
    use({
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" }
          }
        })

        -- ## Mappings
        vim.keymap.set("n", "<leader>gd", "<Cmd>Gitsigns diffthis<CR>")
        vim.keymap.set("n", "<leader>gh", "<Cmd>Gitsigns preview_hunk<CR>")
        vim.keymap.set("n", "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>")
        vim.keymap.set("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>")
        vim.keymap.set("n", "]g", "<Cmd>Gitsigns next_hunk<CR>")
        vim.keymap.set("n", "[g", "<Cmd>Gitsigns prev_hunk<CR>")
      end
    })

    -----------------------------------------------------------
    -- ## Telescope
    -----------------------------------------------------------

    use({
      "nvim-telescope/telescope.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        -- ### Settings
        local telescope = require("telescope")
        telescope.setup({
          pickers = {
            buffers = {
              theme = "dropdown",
              sorting_strategy = "ascending",
              ignore_current_buffer = true,
              sort_mru = true,
              previewer = false,
              mappings = {
                i = {
                  ["<C-d>"] = "delete_buffer"
                }
              }
            },
            lsp_workspace_symbols = {
              symbol_width = 65,
            }
          }
        })
        local t = require("telescope.builtin")

        -- ### Mappings
        vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>")
        vim.keymap.set("n", "<leader>tt", "<Cmd>Telescope resume<CR>")
        vim.keymap.set("n", "<leader>th", "<Cmd>Telescope help_tags<CR>")

        vim.keymap.set("n", "<leader>tf", "<Cmd>Telescope find_files<CR>")
        vim.keymap.set("n", "<leader>tc", "<Cmd>Telescope oldfiles<CR>")

        vim.keymap.set("n", "<leader>tgc", "<Cmd>Telescope git_commits<CR>")
        vim.keymap.set("n", "<leader>tgx", "<Cmd>Telescope git_bcommits<CR>")
        vim.keymap.set("n", "<leader>tgb", "<Cmd>Telescope git_branches<CR>")
        vim.keymap.set("n", "<leader>tgs", "<Cmd>Telescope git_status<CR>")
        vim.keymap.set("n", "<leader>tgh", "<Cmd>Telescope git_stash<CR>")

        vim.keymap.set("n", "<leader>td", "<Cmd>Telescope diagnostics<CR>")
        vim.keymap.set("n", "<leader>to", "<Cmd>Telescope lsp_document_symbols<CR>")
        vim.keymap.set("n", "<leader>tw", "<Cmd>Telescope lsp_workspace_symbols<CR>")

        vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>")
        vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")

        vim.keymap.set("n", "<leader>tl", "<Cmd>Telescope live_grep<CR>")
        vim.keymap.set("v", "<leader>tl", function()
          local text = vim.get_visual_selection()
          t.live_grep({ default_text = text })
        end)

        vim.keymap.set("n", "<leader>tb", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")
        vim.keymap.set("v", "<leader>tb", function()
          local text = vim.get_visual_selection()
          t.current_buffer_fuzzy_find({ default_text = text })
        end)

        vim.keymap.set("n", "<leader>ts", "<Cmd>Telescope grep_string<CR>")
        vim.keymap.set("v", "<leader>ts", function()
          local text = vim.get_visual_selection()
          t.grep_string({ default_text = text })
        end)
      end
    })

    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      requires = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("telescope").load_extension("fzf")
      end
    })

    -----------------------------------------------------------
    -- ## Treesitter
    -----------------------------------------------------------

    use({
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup({
            patterns = {
              default = {
                "class",
                "function",
                "method",
                "for",
                "while",
                "if",
                "else",
                "switch",
                "case"
              },
              javascript = {
                "object",
                "pair"
              },
              ruby = {
                "module",
                "block"
              },
              yaml = {
                "block_mapping_pair",
                "block_sequence_item"
              },
              json = {
                "object",
                "pair",
              },
            },
          })
        end
      },
      { "RRethy/nvim-treesitter-endwise" },
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      requires = { "nvim-treesitter/nvim-treesitter" }
    })


    use({
      "nvim-treesitter/nvim-treesitter",
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end,
      config = function()
        require("nvim-treesitter.configs").setup({
          auto_install = true,
          highlight = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm"
            }
          },
          indent = {
            disable = true
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
              }
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer"
              },
              goto_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer"
              },
              goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
              },
            },
            lsp_interop = {
              enable = true,
              peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer"
              }
            }
          },
          endwise = {
            enable = true
          }
        })
      end
    })

    -----------------------------------------------------------
    -- ## LSP, DAP, linter, formatters
    -----------------------------------------------------------

    -- ### Package manager
    use({
      "williamboman/mason.nvim",
      config = function()
        -- ### Package installer configuration
        require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        })
      end
    })

    -- ### Prepare sources and snippet engine for autocompletion
    use({
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      requires = { "hrsh7th/nvim-cmp" }
    })

    -- ### Autocompletion
    use({
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          -- ### Mappings
          mapping = cmp.mapping.preset.insert({
            ["<C-u>"] = cmp.mapping.scroll_docs(-2),
            ["<C-d>"] = cmp.mapping.scroll_docs(2),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true
            })
          }),
          sources = {
            { name = "nvim_lsp" },
            {
              name = "buffer",
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
                keyword_pattern = [[\k\+]]
              }
            },
            { name = "path" }
          }
        })

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "cmdline" }
          })
        })

        for _, cmd_type in ipairs { "/", "?", } do
          cmp.setup.cmdline(
            cmd_type, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" }
            }
          })
        end
      end
    })

    -- ### LSP config
    use({
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      {
        "neovim/nvim-lspconfig",
        config = function()
          -- ### Diagnositc mappings
          local keymap_opts = { noremap = true, silent = true }
          vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, keymap_opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, keymap_opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, keymap_opts)

          -- ### Mappings
          local on_attach = function(_, bufnr)
            local bufopts = { buffer = bufnr }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gp", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)


            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
            vim.keymap.set("v", "<leader>ca", function()
              vim.lsp.buf.range_code_action()
            end, bufopts)

            vim.keymap.set("n", "<leader>ff", function()
              vim.lsp.buf.format({ async = true })
            end, bufopts)
            vim.keymap.set("v", "<leader>ff", function()
              vim.lsp.buf.range_formatting()
            end, bufopts)

            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set("n", "<leader>wl", function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
          end

          -- ### Capabilities
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

          -- ### LSP servers configuration
          local mason_lsp_config = require("mason-lspconfig")
          mason_lsp_config.setup()
          local installed_servers = mason_lsp_config.get_installed_servers()
          local lspconfig = require("lspconfig")

          -- ### Additional settings for certain LSP servers
          local enhance_server_opts = {
            ["jsonls"] = function(options)
              options.settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true }
                }
              }
            end,
          }

          -- Setup LSP
          for _, server_name in ipairs(installed_servers) do
            local lsp_opts = {
              on_attach = on_attach,
              capabilities = capabilities,
            }
            if enhance_server_opts[server_name] then
              enhance_server_opts[server_name](lsp_opts)
            end
            lspconfig[server_name].setup(lsp_opts)
          end
        end
      }
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        local null_ls = require("null-ls")
        require("null-ls").setup({
          sources = {
            null_ls.builtins.diagnostics.markdownlint
          },
        })
      end
    })

    -----------------------------------------------------------
    -- ## Text editing
    -----------------------------------------------------------

    -- ### Indentation style detection
    use({
      "nmac427/guess-indent.nvim",
      config = function()
        require("guess-indent").setup()
      end
    })

    -- ### Autopairs
    use({
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup()
      end
    })

    -- ### Surrounding
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end
    })

    -- ### Easy tables
    use({
      "dhruvasagar/vim-table-mode",
      config = function()
        vim.g.table_mode_corner = "|"
        vim.g.table_mode_map_prefix = "<Leader>l"
        vim.g.table_mode_update_time = 250
        vim.g.table_mode_auto_align = 1
      end
    })

    -----------------------------------------------------------
    -- ## Other
    -----------------------------------------------------------

    -- ### Autosaving
    use({
      "Pocco81/auto-save.nvim",
      config = function()
        require("auto-save").setup({
          execution_message = {
            message = function()
              return ""
            end
          },
          debounce_delay = 1000
        })
      end,
    })

    -- ### Popup with suggestions to complete a key binding
    use({
      "folke/which-key.nvim",
      config = {
        function()
          require("which-key").setup()
        end
      }
    })

    -- ### Comment lines with shortcuts
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end
    })

    -- ### File explorer
    use({
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        require("nvim-tree").setup()

        -- #### Mappinngs
        vim.keymap.set("n", "<leader><leader>", ":NvimTreeToggle<CR>")
        vim.keymap.set("n", "<C-n>", ":NvimTreeFindFile<CR>")
      end
    })

    -- ### Find and replace across project
    use({
      "nvim-pack/nvim-spectre",
      config = function()
        require("spectre").setup()

        -- #### Mappinngs
        vim.keymap.set("n", "<leader>S", function()
          require("spectre").open()
        end)
        vim.keymap.set("n", "<leader>s", function()
          require("spectre").open_file_search()
        end)
      end
    })

    -----------------------------------------------------------
    -- ## Language specific plugins
    -----------------------------------------------------------

    -- ### Markdown
    use({
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
    })

    -- ### Ruby
    use({ "slim-template/vim-slim" })
  end,
  config = {
    snapshot_path = require("packer.util").join_paths(vim.fn.getenv("HOME"), "dotfiles", "nvim"),
    display = {
      open_fn = require("packer.util").float,
      log = { level = "warn" }
    }
  }
})
