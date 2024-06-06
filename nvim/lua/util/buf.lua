local M = {}

---@param bufnr number
M.get_buf_byte_size = function(bufnr)
    local success, lines = pcall(vim.api.nvim_buf_line_count, bufnr)
    if success then
        return vim.api.nvim_buf_get_offset(bufnr, lines)
    else
        return 0
    end
end

M.cur_buf_dir_abs_path = function()
    return vim.fn.expand("%:p:h")
end

M.get_cur_buf_dir_rel_path = function()
    local path = vim.fn.expand("%:p:.:h")
    if path == "." then
        return ""
    end
    return path .. [[/]]
end

M.get_cur_buf_rel_path = function(should_append_line_num)
    local buf_rel_path = vim.fn.expand("%:p:.")
    if should_append_line_num then
        return buf_rel_path .. ":" .. vim.fn.line(".")
    end
    return vim.fn.expand("%:p:.")
end

M.copy_rel_path_line_to_buffer = function()
    vim.fn.setreg("+", M.get_cur_buf_rel_path(true))
end

M.copy_rel_path_to_buffer = function()
    vim.fn.setreg("+", M.get_cur_buf_rel_path(false))
end

return M
