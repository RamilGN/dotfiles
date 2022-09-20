-----------------------------------------------------------
-- # Settings
-----------------------------------------------------------

-- ## Mouse off
vim.opt.mouse = nil
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
vim.opt.updatetime = 100
vim.opt.timeoutlen = 500
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
-- ## Tabs to spaces
vim.opt.expandtab = true
-- ## Global statusline
vim.opt.laststatus = 3
-- ## Autowrite
vim.opt.autowrite = true
vim.opt.clipboard = "unnamed,unnamedplus"
-- ### Diagnositc
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
-- ## Scrolling up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "]b", "<Cmd>bnext<CR>")
vim.keymap.set("n", "[b", "<Cmd>bprevious<CR>")
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
vim.keymap.set("n", "<leader>vl", "<Cmd>vsp $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>vs", "<Cmd>source $MYVIMRC<CR>")
-- ## Repeat last command
vim.keymap.set("n", "<leader>re", "@:")
-- ## Quit all
vim.keymap.set("n", "ZA", "<Cmd>qa!<CR>")
-- ## Serach word without jumping
vim.keymap.set("n", "#", "<Cmd>let @/= '\\<'.expand('<cword>').'\\>' <bar> set hls <CR>", { silent = true })
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

-----------------------------------------------------------
-- # Commands
-----------------------------------------------------------

-- ## Git

-- ### Git log current file with range(optional)
vim.api.nvim_create_user_command(
  "GitLog",
  function(opts)
    local range = (opts.range == 0 and opts.args) or (opts.line1 .. [[,]] .. opts.line2)
    if range == "" then
      vim.cmd([[vsplit term://git --no-pager log -p --stat --follow ]] .. [[%]])
    else
      vim.cmd([[vsplit term://git --no-pager log -p -L]] .. range .. [[:%]])
    end
  end,
  { nargs = "?", range = true }
)
vim.keymap.set("n", "<leader>gl", "<Cmd>GitLog<CR>")
vim.keymap.set("v", "<leader>gl", "<Cmd>'<,'>GitLog<CR>")

-- ### Git show commit hash
vim.api.nvim_create_user_command(
  "GitShow",
  function(opts)
    local commit_hash = opts.args
    if commit_hash == "" then
      local cword = vim.fn.expand("<cword>")
      vim.cmd([[vsplit term://git --no-pager show -p --stat ]] .. cword)
    else
      vim.cmd([[vsplit term://git --no-pager show -p --stat ]] .. commit_hash)
    end
  end,
  { nargs = "?" }
)
vim.keymap.set("n", "<leader>gi", "<Cmd>GitShow<CR>")

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
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    local value = "100"
    if filetype == "markdown" then
      value = "80"
    elseif filetype == "ruby" then
      value = "120"
    end
    local cval = current == "" and value or ""
    vim.opt.colorcolumn = cval
  end, { nargs = "?", range = true })
-- ### Mappings
vim.keymap.set("n", "yoc", "<Cmd>SetColorColumn<CR>")

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

vim.g.max_byte_size = 1024 * 206

function vim.get_buf_byte_size(bufnr)
  local success, lines = pcall(vim.api.nvim_buf_line_count, bufnr)
  if success then
    return vim.api.nvim_buf_get_offset(bufnr, lines)
  else
    return 0
  end
end

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
    use({
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
    })

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

    -- ### Better ui select and etc.
    use({
      "stevearc/dressing.nvim",
      config = function()
        require("dressing").setup({
          input = {
            get_config = function()
              if vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
                return { min_width = 140 }
              end
            end
          }
        })

        vim.keymap.set("n", "z=", function()
          local word = vim.fn.expand("<cword>")
          local suggestions = vim.fn.spellsuggest(word)
          vim.ui.select(suggestions, {},
            vim.schedule_wrap(function(selected)
              if selected then
                vim.api.nvim_feedkeys("ciw" .. selected, "n", true)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
              end
            end)
          )
        end)

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
        vim.keymap.set("n", "<leader>gb", "<Cmd>Gitsigns blame_line<CR>")
        vim.keymap.set("n", "]g", "<Cmd>Gitsigns next_hunk<CR>")
        vim.keymap.set("n", "[g", "<Cmd>Gitsigns prev_hunk<CR>")
      end
    })

    use {
      "ruifm/gitlinker.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("gitlinker").setup({
          opts = {
            print_url = false,
          },
          callbacks = {
            ["gitlab.insales.ru"] = require("gitlinker.hosts").get_gitlab_type_url
          },
        })
      end
    }

    -----------------------------------------------------------
    -- ## Telescope
    -----------------------------------------------------------

    use({
      "nvim-telescope/telescope.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        -- ### Settings
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        telescope.setup({
          defaults = {
            mappings = {
              i = {
                ["<Esc>"] = actions.close,
                ["<C-\\>"] = actions.close
              },
            },
            dynamic_preview_title = true,
            preview = {
              treesitter = {
                disable = { "eruby" }
              }
            }
          },
          pickers = {
            find_files = {
              find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
            },
            buffers = {
              theme = "dropdown",
              sorting_strategy = "ascending",
              ignore_current_buffer = true,
              sort_mru = true,
              previewer = false,
              mappings = {
                i = {
                  ["<C-d>"] = actions.delete_buffer
                }
              }
            },
            lsp_workspace_symbols = {
              symbol_width = 65
            }
          }
        })
        local t = require("telescope.builtin")

        -- ### Mappings
        vim.keymap.set("n", "<C-b>", "<Cmd>Telescope buffers<CR>") -- up
        vim.keymap.set("n", "<leader>tt", "<Cmd>Telescope resume<CR>")
        vim.keymap.set("n", "<leader>th", "<Cmd>Telescope help_tags<CR>")

        vim.keymap.set("n", "<C-f>", "<Cmd>Telescope find_files<CR>") -- up
        vim.keymap.set("n", "<leader>tc", "<Cmd>Telescope oldfiles<CR>")

        vim.keymap.set("n", "<leader>tgc", "<Cmd>Telescope git_commits<CR>")
        vim.keymap.set("n", "<leader>tgx", "<Cmd>Telescope git_bcommits<CR>")
        vim.keymap.set("n", "<leader>tgb", "<Cmd>Telescope git_branches<CR>")
        vim.keymap.set("n", "<C-g>", "<Cmd>Telescope git_status<CR>") -- up
        vim.keymap.set("n", "<leader>tgh", "<Cmd>Telescope git_stash<CR>")

        vim.keymap.set("n", "<leader>td", "<Cmd>Telescope diagnostics<CR>")
        vim.keymap.set("n", "<leader>to", "<Cmd>Telescope lsp_document_symbols<CR>")
        vim.keymap.set("n", "<leader>tw", "<Cmd>Telescope lsp_workspace_symbols<CR>")

        vim.keymap.set("n", "<C-m>", "<Cmd>Telescope live_grep<CR>")
        vim.keymap.set("v", "<C-m>", function()
          local text = vim.get_visual_selection()
          t.live_grep({ default_text = text })
        end)

        vim.keymap.set("n", "<leader>b", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")
        vim.keymap.set("v", "<leader>b", function()
          local text = vim.get_visual_selection()
          t.current_buffer_fuzzy_find({ default_text = text })
        end)

        vim.keymap.set("n", "<leader>ts",
          function()
            require("telescope.builtin").grep_string({ search = vim.fn.input("> ") })
          end)
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
      { "windwp/nvim-ts-autotag" },
      requires = { "nvim-treesitter/nvim-treesitter" }
    })


    use({
      "nvim-treesitter/nvim-treesitter",
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end,
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = "all",
          sync_install = false,
          highlight = {
            enable = true,
            disable = function(_, bufnr)
              return vim.get_buf_byte_size(bufnr) > vim.g.max_byte_size
            end,
          },
          additional_vim_regex_highlighting = false,
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
          },
          autotag = {
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

        local buffer_source = {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local bufs = vim.api.nvim_list_bufs()
              for i, buf in ipairs(bufs) do
                local byte_size = vim.get_buf_byte_size(buf)
                if byte_size > vim.g.max_byte_size then
                  table.remove(bufs, i)
                end
              end
              return bufs
            end,
            keyword_pattern = [[\k\+]]
          }
        }

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
            buffer_source,
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
              buffer_source
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
            vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>")
            vim.keymap.set("n", "gd", "<Cmd>Telescope lsp_definitions<CR>")
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
          mason_lsp_config.setup({
            ensure_installed = {
              "sumneko_lua",
              "solargraph",
              "gopls",
              "sqlls",
              "pylsp",
              "pyright",
              "dockerls",
              "bashls",
              "eslint",
              "html",
              "cssls",
              "jsonls",
              "yamlls",
              "dockerls"
            }
          })
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
        vim.g.table_mode_map_prefix = "<Leader><Bar>"
        vim.g.table_mode_update_time = 250
        vim.g.table_mode_auto_align = 1
      end
    })

    -----------------------------------------------------------
    -- ## Other
    -----------------------------------------------------------

    -- ### Autosaving
    use({
      "RamiGaggi/auto-save.nvim",
      config = function()
        require("auto-save").setup({
          execution_message = {
            message = function()
              return ""
            end
          },
          condition = function(buf)
            local utils = require("auto-save.utils.data")
            local can_save = vim.fn.getbufvar(buf, "&modifiable") == 1
                and utils.not_in(vim.fn.getbufvar(buf, "&filetype"), {})
                and vim.get_buf_byte_size(buf) < vim.g.max_byte_size
            if can_save then
              return true
            end
            return false
          end,
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
        require("nvim-tree").setup({
          view = {
            signcolumn = "no",
            centralize_selection = true,
            relativenumber = true,
            number = true
          },
          renderer = {
            full_name = true,
            indent_width = 1,
          },
        })

        -- #### Mappinngs
        vim.keymap.set("n", "<leader><leader>", "<Cmd>NvimTreeToggle<CR>")
        vim.keymap.set("n", "<C-n>", "<Cmd>NvimTreeFindFile<CR>")
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

    -- ### Terminal management
    use(
      {
        "akinsho/toggleterm.nvim", tag = "v2.*",
        config = function()
          local toggleterm = require("toggleterm")

          toggleterm.setup {
            size = function(term)
              if term.direction == "horizontal" then
                return 20
              elseif term.direction == "vertical" then
                return math.floor(vim.o.columns * 0.4)
              end
            end,
            open_mapping = [[<C-\>]],
            insert_mappings = true,
            persist_size = false,
            persist_mode = false,
            direction = "float",
            float_opts = {
              border = "rounded",
              winblend = 5
            },
          }

          vim.keymap.set("n", "<leader>rt", "<Cmd>1ToggleTerm direction=float<CR>")

          vim.api.nvim_create_user_command("ToggleTermSendCurrentLineNoTW",
            function(opts)
              toggleterm.send_lines_to_terminal("single_line", false, opts)
            end,
            { nargs = "?" }
          )
          vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionNoTW",
            function(opts)
              toggleterm.send_lines_to_terminal("visual_selection", false, opts)
            end,
            { range = true, nargs = "?" }
          )
          vim.keymap.set("n", "<leader>rl", "<Cmd>2ToggleTerm direction=vertical<CR>")
          vim.keymap.set("n", "<C-s>", "<Cmd>ToggleTermSendCurrentLineNoTW 2<CR>")
          vim.keymap.set("v", "<C-s>", ":ToggleTermSendVisualSelectionNoTW 2<CR>")
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
