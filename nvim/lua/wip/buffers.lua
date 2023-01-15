Buffers = {}

vim.api.nvim_create_user_command("AddToBuffer",
    function()
        local x = os.clock()
        table.insert(Buffers, x)
        -- local n_buf = vim.g.n_buffers
        -- n_buf.last_index = n_buf.last_index + 1
        -- vim.g.n_buffers = n_buf
        vim.pretty_print(Buffers)
    end, { nargs = 0 })

