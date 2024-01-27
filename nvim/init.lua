local core = {
    bootstrap_package_manager = function()
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
            vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                lazypath,
            })
        end
        vim.opt.rtp:prepend(lazypath)
    end,
    setup = function()
        require("lazy").setup("plugins", {
            change_detection = {
                notify = false,
            },
            dev = {
                path = "~/dotfiles/nvim/lua/dev",
            },
        })

        require("gitx").setup()
        require("runner").setup()
    end,
}

require("config").setup(core)
