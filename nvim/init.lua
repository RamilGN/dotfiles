local core = {
    bootstrap_package_manager = function()
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
            vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
            })
        end
        vim.opt.rtp:prepend(lazypath)
    end,
    setup_plugins = function()
        require("lazy").setup("plugins", {
            ui = {
                icons = {
                    lazy = " "
                }
            },
            change_detection = {
                notify = false
            },
        })
    end
}

require("config").setup(core)
