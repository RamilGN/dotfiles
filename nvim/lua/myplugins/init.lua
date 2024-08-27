return {
    setup = function()
        require("myplugins.git.init").setup()
        require("myplugins.term.init").setup()
        require("myplugins.runner.init").setup()
        require("myplugins.qf.init").setup()
        require("myplugins.go.init").setup()
        require("myplugins.ai.init").setup()
    end,
}
