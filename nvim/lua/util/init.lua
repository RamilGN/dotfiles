---@class Util
local M = {}

M.keys = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", true)
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
