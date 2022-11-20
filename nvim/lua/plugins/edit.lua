local M = {}

function M.setup(use)
  -- Autopairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  })

  -- Surrounding
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  })

  -- Easy tables
  use({
    "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_map_prefix = "<Leader><Bar>"
      vim.g.table_mode_update_time = 250
      vim.g.table_mode_auto_align = 1
    end
  })
end

return M
