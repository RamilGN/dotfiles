---@class Util
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

M.get_visual_selection_v2 = function()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end

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

M.keys = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", true)
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

return M
