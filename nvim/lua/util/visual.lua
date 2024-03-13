local M = {}

M.get_visual_selection_for_telescope = function()
    vim.cmd([[noau normal! "vy]])
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ""
    end
end

M.get_visual_selection_lines = function()
    local mode = vim.fn.visualmode()

    -- Get the start and the end of the selection
    local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
    local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
    local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    local res = {
        start_pos = { start_line, start_col },
        end_pos = { end_line, end_col },
        selected_lines = selected_lines,
    }
    -- Line-visual.
    -- Returns lines encompassed by the selection - already in result object.
    if mode == "V" then
        return res.selected_lines
    end

    -- Regular-visual.
    -- Returns the buffer text encompassed by the selection.
    if mode == "v" then
        start_line, start_col = unpack(res.start_pos)
        end_line, end_col = unpack(res.end_pos)
        -- Exclude the last char in text if "selection" is set to "exclusive"
        if vim.opt.selection:get() == "exclusive" then
            end_col = end_col - 1
        end
        return vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})
    end

    -- Block-visual
    -- Return the lines encompassed by the selection, each truncated by the start and end columns.
    if mode == "\x16" then
        _, start_col = unpack(res.start_pos)
        _, end_col = unpack(res.end_pos)
        -- Exclude the last col of the block if "selection" is set to "exclusive"
        if vim.opt.selection:get() == "exclusive" then
            end_col = end_col - 1
        end

        -- Exchange start and end columns for proper substring indexing if needed.
        -- E.g. instead of str:sub(10, 5), do str:sub(5, 10).
        if start_col > end_col then
            start_col, end_col = end_col, start_col
        end

        -- Iterate over lines, truncating each one.
        return vim.tbl_map(function(line)
            return line:sub(start_col, end_col)
        end, res.selected_lines)
    end

    return {}
end

---@return string lines
M.get_visual_selection_text = function()
    local lines = M.get_visual_selection_lines()
    return table.concat(lines, "\n")
end

return M
