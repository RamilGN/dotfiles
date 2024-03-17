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

return M
