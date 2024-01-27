return {
    setup = function()
        -- Set color bar
        vim.api.nvim_create_user_command("SetColorColumn", function()
            vim.opt.colorcolumn = tostring(vim.v.count)
        end, { nargs = "?", count = true })
        -- Run in terminal
        vim.api.nvim_create_user_command("V", function(opts)
            require("util.vim").vterm("/bin/zsh -i -c '" .. opts.fargs[1] .. "'")
        end, { nargs = 1 })
        -- Run current file
        vim.api.nvim_create_user_command("Run", function(opts)
            local f = require("functions")

            f.runner.run(opts)
        end, { nargs = "*", range = true })
    end,
}
