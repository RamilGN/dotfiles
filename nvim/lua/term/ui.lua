local M = {}
local P = {}

M.open_enew = function(term)
    -- TODO: It's awful...
    if term.open == false then
        return
    end

    vim.cmd(TERM_TYPE_ENEW)

    term.buf_id = vim.api.nvim_get_current_buf()
    term.win_id = vim.api.nvim_get_current_win()
    term.open = true
    term.type = TERM_TYPE_ENEW

    term.closer = function()
        term.open = false
    end
    term.opener = function()
        M.open_enew(term)
    end

    P.setup_bufwinleave_autocmd(term)

    return term
end

---@param term Term
---@return Term
M.open_vsplit = function(term)
    vim.cmd(TERM_TYPE_VSPLIT)

    P.get_or_create_buf_for(term)
    vim.api.nvim_set_current_buf(term.buf_id)

    term.win_id = vim.api.nvim_get_current_win()
    term.open = true
    term.type = TERM_TYPE_VSPLIT

    term.closer = function()
        term.open = false

        if vim.api.nvim_win_is_valid(term.win_id) then
            vim.api.nvim_win_close(term.win_id, true)
        end
    end
    term.opener = function()
        M.open_vsplit(term)
    end

    P.setup_bufwinleave_autocmd(term)

    return term
end

---@param term Term
P.setup_bufwinleave_autocmd = function(term)
    vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = term.buf_id,
        group = TERM_AUGROUP,
        callback = term.closer,
    })
end

---@param term Term
---@return Term
M.open_float = function(term)
    P.get_or_create_buf_for(term)

    term.win_id = vim.api.nvim_open_win(term.buf_id, true, P.get_float_config())
    term.open = true
    term.type = TERM_TYPE_FLOAT

    term.closer = function()
        term.open = false

        if vim.api.nvim_win_is_valid(term.win_id) then
            vim.api.nvim_win_close(term.win_id, true)
        end
    end
    term.opener = function()
        M.open_float(term)
    end

    vim.wo[term.win_id].winhighlight = "FloatBorder:TermBorder,NormalFloat:TermNormalFloat"

    P.setup_float_autocmd(term)

    return term
end

---@param term Term
P.setup_float_autocmd = function(term)
    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = term.buf_id,
        group = TERM_AUGROUP,
        callback = term.closer,
    })
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

---@param term Term
P.get_or_create_buf_for = function(term)
    local buf_id = term.buf_id

    if buf_id == nil or not vim.api.nvim_buf_is_valid(term.buf_id) then
        buf_id = vim.api.nvim_create_buf(false, false)
    end

    term.buf_id = buf_id
end

return M
