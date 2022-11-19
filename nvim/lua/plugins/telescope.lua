local M = {}

function M.setup(use)
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
end

return M
