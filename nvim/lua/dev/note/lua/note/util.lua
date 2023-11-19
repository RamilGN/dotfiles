local M = {}

M.create_today_journal = function(dir)
    local dirname = vim.loop.fs_realpath(dir) or vim.fn.mkdir(dir)
    local filename = dirname .. "/" .. os.date("%Y_%m_%d") .. ".md"
    vim.cmd("e " .. filename)
end

return M
