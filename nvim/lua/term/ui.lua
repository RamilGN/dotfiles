local M = {}
local P = {}

---@param term Term
---@return Term
M.open_float = function(term)
    local buf_id = term.buf_id

    if buf_id == nil or not vim.api.nvim_buf_is_valid(term.buf_id) then
        buf_id = vim.api.nvim_create_buf(false, false)
    end

    local win_id = vim.api.nvim_open_win(buf_id, true, P.get_float_config())

    term.buf_id = buf_id
    term.win_id = win_id
    term.open = true
    term.type = TERM_TYPE_FLOAT

    term.closer = function()
        term.open = false
        vim.api.nvim_win_close(term.win_id, true)
    end
    term.opener = function()
        M.open_float(term)
    end

    return term
end

P.get_float_config = function()
    local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 20)))
    local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))
    local row = math.ceil(vim.o.lines - height) * 0.5 - 1
    local col = math.ceil(vim.o.columns - width) * 0.5 - 1

    local float_config = {
        row = row,
        col = col,
        relative = "editor",
        style = "minimal",
        width = width,
        height = height,
        border = "single",
    }

    return float_config
end

return M
