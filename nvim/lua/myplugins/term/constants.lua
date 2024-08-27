local M = {
    types = {
        FLOAT = "float",
        VSPLIT = "vsplit",
        ENEW = "enew",
    },
    line_modes = {
        LINE = "line",
        LINES = "lines",
    },
    kitty = {
        columns_start = 65,
        columns_end = 98,
        cmd = "kitty @ send-text --match neighbor:right",
    },
    AUGROUP = vim.api.nvim_create_augroup("Term", { clear = true }),
}

return M
