---@class Util
local M = {}

M.keys = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", true)
end

---@param bufnr number
M.get_buf_byte_size = function(bufnr)
    local success, lines = pcall(vim.api.nvim_buf_line_count, bufnr)
    if success then
        return vim.api.nvim_buf_get_offset(bufnr, lines)
    else
        return 0
    end
end

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

M.get_cur_buf_dir_rel_path = function()
    local path = vim.fn.expand("%:p:.:h")
    if path == "." then
        return ""
    end
    return path .. [[/]]
end

M.cur_buf_dir_abs_path = function()
    return vim.fn.expand("%:p:h")
end

M.save_last_command = function(command, cmd)
    vim.g.previous_command = vim.g.last_command
    vim.g.last_command = command
    vim.g.last_cmd = cmd
end

M.vterm = function(command, opts)
    opts = opts or {}
    local curfile = vim.fn.expand("%")
    local full_command = ([[term ]] .. command .. [[ && sleep 0.1]])
    local expanded_command = full_command.gsub(full_command, "%%", curfile)
    M.save_last_command(expanded_command, command)
    vim.cmd(expanded_command)
end

M.input = function(name, func)
    return function()
        vim.ui.input(name, function(input)
            if not input then
                return
            end
            func(input)
        end)
    end
end

M.sysopen = function(filename)
    local command = "xdg-open " .. filename
    return vim.fn.jobstart(command)
end

return M
