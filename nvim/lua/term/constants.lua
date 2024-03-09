TERM_TYPE_FLOAT = "float"
TERM_TYPE_VSPLIT = "vsplit"

TERM_SEND_MODE_LINE = "line"
TERM_SEND_MODE_LINES = "lines"

TERM_AUGROUP = vim.api.nvim_create_augroup("Term", { clear = true })

TERM_CMD_COMPLETE_REGEXP = "^%s*Term (.*) (.*)"
TERM_CMD_COMPLETE_ARG = "id="
