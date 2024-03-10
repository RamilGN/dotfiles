--- @alias TermType string
--- @type TermType
TERM_TYPE_FLOAT = "float"
--- @type TermType
TERM_TYPE_VSPLIT = "vsplit"
--- @type TermType
TERM_TYPE_ENEW = "enew"

---@alias TermSendMode string
---@type TermSendMode
TERM_SEND_MODE_LINE = "line"
---@type TermSendMode
TERM_SEND_MODE_LINES = "lines"

TERM_AUGROUP = vim.api.nvim_create_augroup("Term", { clear = true })

TERM_CMD_COMPLETE_REGEXP = "^%s*Term (.*) (.*)"
TERM_CMD_COMPLETE_ARG = "id="

TERM_KITTY_COLUMNS = 98
TERM_KITTY_CMD = "kitty @ send-text --match neighbor:right"
