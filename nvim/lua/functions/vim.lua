local M = {}

M.closewin = function()
    vim.cmd([[q]])
end

M.curwin = function()
    local cw = vim.api.nvim_get_current_win()
    return {
        id = cw,
        back = function()
            vim.api.nvim_set_current_win(cw)
        end
    }
end

M.get_buf_byte_size = function(bufnr)
    local success, lines = pcall(vim.api.nvim_buf_line_count, bufnr)
    if success then
        return vim.api.nvim_buf_get_offset(bufnr, lines)
    else
        return 0
    end
end

M.get_visual_selection = function()
    vim.cmd([[noau normal! "vy"]])
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ""
    end
end

M.get_cur_buf_rel_path = function()
    vim.fn.expand("%:p:.")
end

M.get_cur_buf_dir_rel_path = function()
    local path = vim.fn.expand("%:p:.:h")
    if path == "." then
        return ""
    end
    return path .. [[/]]
end

M.vterm = function(command)
    local curwin = M.curwin()
    vim.cmd([[vsplit term://]] .. command .. [[ && sleep 0.1]])
    curwin.back()
end

return M
