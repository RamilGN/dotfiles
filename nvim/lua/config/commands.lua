return {
    setup = function()
        -- Set color bar
        vim.api.nvim_create_user_command("SetColorColumn", function()
            vim.opt.colorcolumn = tostring(vim.v.count)
        end, { nargs = "?", count = true })
    end,
}
