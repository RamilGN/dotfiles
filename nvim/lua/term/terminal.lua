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

---@type Term[]
local Terminals = {}

---@type Term|nil
local LastTerminal = nil

local M = {
    last_terminal = LastTerminal,
    terminals = Terminals,
}
local P = {}

---@param id integer
---@return Term
M.open = function(id)
    id = P.get_id(id)

    local term = M.terminals[id]
    if term and term.open then
        return term
    elseif term then
        term.opener()
    else
        term = P.new_term(id)
    end

    M.last_terminal = term

    return term
end

---@param id integer
---@return Term
M.toggle = function(id)
    id = P.get_id(id)

    local term = M.terminals[id]
    if term and term.open then
        term.closer()
    elseif term then
        term.opener()
    else
        term = P.new_term(id)
    end

    M.last_terminal = term

    return term
end

---@param id integer
---@param mode string
---@return Term|nil
M.send = function(id, mode)
    local lines = {}

    if mode == TERM_SEND_MODE_LINE then
        lines = { vim.api.nvim_get_current_line() }
    elseif mode == TERM_SEND_MODE_LINES then
        lines = Util.get_visual_selection_lines()
    end

    if #lines == 0 then
        return
    end

    local term = M.open(id)

    for _, line in ipairs(lines) do
        line = string.format("%s\n", line)
        vim.fn.chansend(term.job_id, line)
    end

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
            M.terminals[term.id] = nil
            vim.api.nvim_buf_delete(term.buf_id, { force = true })
        end,
    })
end

---@param id integer
---@return integer
P.get_id = function(id)
    if id == 0 and M.last_terminal then
        id = M.last_terminal.id
    elseif id == 0 then
        id = 1
    end

    return id
end

---@param id integer
---@return Term
P.new_term = function(id)
    local term = { id = id }
    term = UI.open_vsplit(term)

    P.setup_buffer_autocommands(term)
    P.start(term)
    P.add(term)

    return term
end

---@param term Term
P.add = function(term)
    vim.validate({
        id = { term.id, "number" },
    })

    M.terminals[term.id] = term
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
