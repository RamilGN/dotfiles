require("packer").startup({
  function(use)
    use({ "wbthomason/packer.nvim" })

    require("plugins.ui").setup(use)
    require("plugins.git").setup(use)
    require("plugins.telescope").setup(use)
    require("plugins.treesitter").setup(use)
    require("plugins.lsp").setup(use)
    require("plugins.edit").setup(use)
    require("plugins.miscellaneous").setup(use)
  end,

  config = {
    snapshot_path = require("packer.util").join_paths(vim.g.home_dir, "dotfiles", "nvim"),
    display = {
      open_fn = require("packer.util").float,
      log = { level = "warn" }
    }
  }
})
