return {
    setup = function()
        -- Set color bar
        vim.api.nvim_create_user_command("SetColorColumn", function()
            vim.opt.colorcolumn = tostring(vim.v.count)
        end, { nargs = "?", count = true })
        -- Run in terminal
        vim.api.nvim_create_user_command("V", function(opts)
            require("util.init").vterm("/bin/zsh -i -c '" .. opts.fargs[1] .. "'")
        end, { nargs = 1 })
    end,
}
