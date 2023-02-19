return {
    setup = function(core)
        core.bootstrap_package_manager()
        require("config.options")
        core.setup_plugins()

        require("config.keymaps")
        require("config.autocommands")
        require("config.commands")
    end
}
