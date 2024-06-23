return {
    setup = function(core)
        core.bootstrap_package_manager()
        require("config.options").setup()
        require("config.keymaps").core()
        require("config.autocommands").setup()
        core.setup()
    end,
}
