---@class Util
local M = {}

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

M.sysopen = function(filename)
    local command = "xdg-open " .. filename
    return vim.fn.jobstart(command)
end

M.copy_to_clipboard = function(text)
    vim.fn.setreg("+", text)
end

M.quickfix_files = function()
    local qflist = vim.fn.getqflist()
    local files = {}

    for _, v in pairs(qflist) do
        local path = vim.fn.bufname(v.bufnr)
        files[path] = true
    end

    return vim.tbl_keys(files)
end

return M
