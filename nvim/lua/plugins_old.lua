require("packer").startup({
  function(use)
    use({ "wbthomason/packer.nvim" })
    require("cfgs.ui").setup(use)

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
            untracked = { text = "+" },
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

    use({
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
        local actions = require("telescope.actions")
        telescope.setup({
          defaults = {
            mappings = {
              i = {
                ["<Esc>"] = actions.close,
                ["<C-\\>"] = actions.close,
                ["<C-j>"] = { "<C-^>", type = "command" }
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
            },
            lsp_document_symbols = {
              theme = "dropdown",
              previewer = false
            }
          }
        })
        local t = require("telescope.builtin")
        local utils = require("utils")

        -- ### Mappings
        vim.keymap.set("n", "<leader>thh", "<Cmd>Telescope help_tags<CR>")
        vim.keymap.set("n", "<leader>thm", "<Cmd>Telescope man_pages<CR>")

        vim.keymap.set("n", "<C-b>", "<Cmd>Telescope buffers<CR>")
        vim.keymap.set("n", "<leader>tt", "<Cmd>Telescope resume<CR>")

        vim.keymap.set("n", "<leader>tc", function()
          t.oldfiles({ only_cwd = true })
        end)

        vim.keymap.set("n", "<leader>tgc", "<Cmd>Telescope git_commits<CR>")
        vim.keymap.set("n", "<leader>tgx", "<Cmd>Telescope git_bcommits<CR>")
        vim.keymap.set("n", "<leader>tgb", "<Cmd>Telescope git_branches<CR>")
        vim.keymap.set("n", "<C-g>", "<Cmd>Telescope git_status<CR>")
        vim.keymap.set("n", "<leader>tgh", "<Cmd>Telescope git_stash<CR>")

        vim.keymap.set("n", "<leader>td", "<Cmd>Telescope diagnostics<CR>")
        vim.keymap.set("n", "<C-q>", "<Cmd>Telescope lsp_document_symbols<CR>")
        vim.keymap.set("n", "<leader>tw", "<Cmd>Telescope lsp_workspace_symbols<CR>")

        vim.keymap.set("n", "<C-f>", "<Cmd>Telescope find_files<CR>")
        vim.keymap.set("v", "<C-f>", function()
          local text = utils.get_visual_selection()
          t.find_files({ default_text = text })
        end)

        vim.keymap.set("n", "<C-m>", "<Cmd>Telescope live_grep<CR>")
        vim.keymap.set("v", "<C-m>", function()
          local text = utils.get_visual_selection()
          t.live_grep({ default_text = text })
        end)

        vim.keymap.set("n", "<leader>b", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")
        vim.keymap.set("v", "<leader>b", function()
          local text = utils.get_visual_selection()
          t.current_buffer_fuzzy_find({ default_text = text })
        end)

        vim.keymap.set("n", "<leader>ts", function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("> ") })
        end)
        vim.keymap.set("v", "<leader>ts", function()
          local text = utils.get_visual_selection()
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
              local utils = require("utils")
              return utils.get_buf_byte_size(bufnr) > vim.g.max_byte_size
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
      "hrsh7th/cmp-nvim-lsp-document-symbol",
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
        local ex_filetypes = {
          ["toggleterm"] = true,
          ["help"] = true
        }

        local buffer_source = {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local bufs = vim.api.nvim_list_bufs()
              for i, buf in ipairs(bufs) do
                local utils = require("utils")
                local byte_size = utils.get_buf_byte_size(buf)

                local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
                if byte_size > vim.g.max_byte_size or ex_filetypes[filetype] then
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
            { name = "nvim_lsp_document_symbol" },
            buffer_source,
            { name = "path" }
          },
          experimental = {
            ghost_text = true,
          },
          formatting = {
            format = require("lspkind").cmp_format(),
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
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
        local utils = require("utils")
        require("auto-save").setup({
          execution_message = {
            message = function()
              return ""
            end
          },
          condition = function(buf)
            local autils = require("auto-save.utils.data")
            local can_save = vim.fn.getbufvar(buf, "&modifiable") == 1
                and autils.not_in(vim.fn.getbufvar(buf, "&filetype"), {})
                and utils.get_buf_byte_size(buf) < vim.g.max_byte_size
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
    use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({
          popup_border_style = "rounded",
          filesystem = {
            hijack_netrw_behavior = "open_default",
            use_libuv_file_watcher = true,
            window = {
              mappings = {
                ["f"] = "fuzzy_finder",
                ["F"] = "filter_on_submit",
                ["/"] = "noop",
                ["o"] = "system_open",
                ["i"] = "run_command",
                ["gy"] = "copy_path",
              }
            },
            commands = {
              system_open = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.api.nvim_command([[silent !xdg-open ]] .. path)
              end,
              run_command = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.api.nvim_input(": " .. path .. "<Home>")
              end,
              copy_path = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.setreg("+", path)
              end,
            },
          },
          event_handlers = {
            { event = "neo_tree_buffer_enter",
              handler = function()
                vim.o.number = true
                vim.o.relativenumber = true
              end },
          }
        })

        -- #### Mappinngs
        vim.keymap.set("n", "<leader><leader>", ":Neotree toggle<CR>")
        vim.keymap.set("n", "<C-n>", ":Neotree reveal<CR>")
      end
    }

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
  end,
  config = {
    snapshot_path = require("packer.util").join_paths(vim.g.home_dir, "dotfiles", "nvim"),
    display = {
      open_fn = require("packer.util").float,
      log = { level = "warn" }
    }
  }
})
