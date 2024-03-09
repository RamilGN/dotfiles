local Util = require("util.init")
local UI = require("term.ui")

--- @class Term
--- @field id integer
--- @field type string
--- @field open boolean
--- @field opener fun()
--- @field closer fun()
--- @field job_id integer
--- @field buf_id integer
--- @field win_id integer

--- @class TermSendModesLine
--- @field value string

--- @class TermSendModesLines
--- @field value string

--- @class TermOpts
--- @field id integer
--- @field cmd string
--- @field send_mode string

---@type Term|nil
local LastTerminal = nil

local M = {
    last_terminal = LastTerminal,
    terminals = {
        ---@type Term[]
        [TERM_TYPE_VSPLIT] = {},
        ---@type Term[]
        [TERM_TYPE_FLOAT] = {},
    },
}
local P = {}

---@param id integer
---@param type string
---@return Term
M.open = function(id, type)
    local term = P.get(id, type)

    if term and term.open then
        return term
    elseif term then
        term.opener()
    else
        term = P.new_term(id, type)
    end

    M.last_terminal = term

    return term
end

---@param id integer
---@param type string
---@return Term
M.toggle = function(id, type)
    local term = P.get(id, type)

    if term and term.open then
        term.closer()
    elseif term then
        term.opener()
    else
        term = P.new_term(id, type)
    end

    M.last_terminal = term

    return term
end

---@param id integer
---@param mode string
---@param type string
---@return Term|nil
M.send = function(id, mode, type)
    local lines = {}

    if mode == TERM_SEND_MODE_LINE then
        lines = { vim.api.nvim_get_current_line() }
    elseif mode == TERM_SEND_MODE_LINES then
        lines = Util.get_visual_selection_lines()
    end

    if #lines == 0 then
        return
    end

    local term = nil
    if M.last_terminal then
        term = M.open(M.last_terminal.id, M.last_terminal.type)
    else
        term = M.open(id, type)
    end

    for _, line in ipairs(lines) do
        line = string.format("%s\n", line)
        vim.fn.chansend(term.job_id, line)
    end

    M.last_terminal = term

    return term
end

---@param term Term
P.start = function(term)
    vim.validate({
        id = { term.id, "number" },
        buf_id = { term.buf_id, "number" },
    })

    local shell = vim.o.shell
    local cmd = string.format("%s;#term%s", shell, term.id)

    vim.cmd("startinsert")

    term.job_id = vim.fn.termopen(cmd, {
        cwd = vim.loop.cwd(),
        on_stdout = function()
            local mode = vim.api.nvim_get_mode().mode

            -- Scroll to bottom.
            vim.api.nvim_buf_call(term.buf_id, function()
                if mode == "n" or mode == "nt" then
                    vim.cmd("normal! G")
                end
            end)
        end,
        on_exit = function()
            P.delete(term)
            vim.api.nvim_buf_delete(term.buf_id, { force = true })
        end,
    })
end

---@param id integer
---@param type string
---@return Term
P.get = function(id, type)
    if id == 0 and M.last_terminal then
        id = M.last_terminal.id
    elseif id == 0 then
        id = 1
    end

    return M.terminals[type][id]
end

---@param id integer
---@param type string
P.get_key = function(id, type)
    return string.format("%d_%s", id, type)
end

---@param id integer
---@param type string
---@return Term
P.new_term = function(id, type)
    local term = { id = id }
    if type == TERM_TYPE_FLOAT then
        term = UI.open_float(term)
    elseif type == TERM_TYPE_VSPLIT then
        term = UI.open_vsplit(term)
    end

    P.setup_buffer_autocommands(term)
    P.start(term)
    P.add(term)

    return term
end

---@param term Term
P.add = function(term)
    M.terminals[term.type][term.id] = term
end

---@param term Term
P.delete = function(term)
    M.terminals[term.type][term.id] = nil
end

---@param term Term
P.setup_buffer_autocommands = function(term)
    vim.api.nvim_create_autocmd("BufEnter", {
        buffer = term.buf_id,
        group = TERM_AUGROUP,
        callback = function()
            vim.cmd("startinsert")
        end,
    })
end

return M
