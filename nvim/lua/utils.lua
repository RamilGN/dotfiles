local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local M = {}

function M.get_buf_byte_size(bufnr)
    local success, lines = pcall(api.nvim_buf_line_count, bufnr)
    if success then
        return api.nvim_buf_get_offset(bufnr, lines)
    else
        return 0
    end
end

function M.get_visual_selection()
    cmd([[noau normal! "vy"]])
    local text = fn.getreg("v")
    fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ""
    end
end

function M.get_cur_buf_rel_path()
    return fn.expand("%")
end

function M.get_cur_buf_dir_rel_path()
    local path = M.get_cur_buf_rel_path()
    return path:gsub("/[^/]*$", "")
end

function M.vterm(command)
    cmd([[vsplit term://]] .. command .. [[ && sleep 0.1]])
end

function M.closewin()
    cmd([[q]])
end

function M.gitdelta(command)
    local delta = [[git --no-pager ]] .. command .. [[ \| delta --paging=never]]
    M.vterm(delta)
end

return M
