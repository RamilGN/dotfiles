local M = {}

M.vim = {
    get_buf_byte_size = function(bufnr)
        local success, lines = pcall(vim.api.nvim_buf_line_count, bufnr)
        if success then
            return vim.api.nvim_buf_get_offset(bufnr, lines)
        else
            return 0
        end
    end,

    get_visual_selection = function()
        vim.cmd([[noau normal! "vy"]])
        local text = vim.fn.getreg("v")
        vim.fn.setreg("v", {})

        text = string.gsub(text, "\n", "")
        if #text > 0 then
            return text
        else
            return ""
        end
    end,

    get_cur_buf_dir_rel_path = function()
        local path = vim.fn.expand("%:p:.:h")
        if path == "." then
            return ""
        end
        return path .. [[/]]
    end,

    vterm = function(command)
        vim.cmd([[vsplit term://]] .. command .. [[ && sleep 0.1]])
    end,

    closewin = function()
        vim.cmd([[q]])
    end
}

M.git = {
    delta = function(command)
        local delta = [[git --no-pager ]] .. command .. [[ \| delta --paging=never]]
        M.vterm(delta)
    end,

    check = function()
        vim.cmd([[silent! !git rev-parse]])
        if vim.v.shell_error == 0 then
            return true
        else
            return false
        end
    end
}

return M
