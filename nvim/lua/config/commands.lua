return {
    setup = function()
        -- Set color bar
        vim.api.nvim_create_user_command("SetColorColumn", function()
            vim.opt.colorcolumn = tostring(vim.v.count)
        end, { nargs = "?", count = true })

        vim.api.nvim_create_user_command("Bwipe", function()
            local bufs = vim.api.nvim_list_bufs()

            for _, buf in ipairs(bufs) do
                if not vim.api.nvim_buf_is_loaded(buf) then
                    vim.cmd(string.format("bwipeout %d", buf))
                end
            end
        end, { nargs = "?", count = true })
    end,
}
