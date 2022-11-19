local M = {}

function M.setup(use)
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

  -- Markdown
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })
end

return M
