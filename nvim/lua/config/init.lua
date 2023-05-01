return {
    setup = function(core)
        core.bootstrap_package_manager()
        require("config.options").setup()
        core.setup_plugins()
        require("config.keymaps").setup()
        require("config.keymaps_new").core()
        require("config.autocommands").setup()
        require("config.commands").setup()
    end
}
