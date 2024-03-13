local UtilVisual = require("util.visual")
local UI = require("term.ui")

--- @class Term
--- @field id integer
--- @field type string
--- @field cmd string
--- @field close_on_exit boolean
--- @field open boolean
--- @field opener fun()
--- @field closer fun()
--- @field job_id integer
--- @field buf_id integer
--- @field win_id integer
local Term = {}

--- @class TermNew
--- @field id? integer
--- @field type? string
--- @field cmd? string
--- @field close_on_exit? boolean

---@type Term|nil
local LastTerminal = nil

local M = {
    last_terminal = LastTerminal,
    terminals = {
        ---@type Term[]
        [TERM_TYPE_VSPLIT] = {},
        ---@type Term[]
        [TERM_TYPE_FLOAT] = {},
        ---@type Term[]
        [TERM_TYPE_ENEW] = {},
    },
}
local P = {}

---@param termopts TermNew
---@return Term
function Term:new(termopts)
    local term = {
        id = termopts.id,
        type = termopts.type,
        cmd = termopts.cmd,
        close_on_exit = termopts.close_on_exit,
    }

    if term.type == nil then
        term.type = TERM_TYPE_FLOAT
    end

    if term.id == 0 or term.id == nil then
        term.id = P.get_next_id(termopts.type)
    end

    if term.cmd == nil then
        term.cmd = vim.o.shell
    end

    if term.close_on_exit == nil then
        term.close_on_exit = true
    end

    return term
end

---@param term Term
---@return Term
M.new = function(term)
    if term.type == TERM_TYPE_FLOAT then
        UI.open_float(term)
    elseif term.type == TERM_TYPE_VSPLIT then
        UI.open_vsplit(term)
    elseif term.type == TERM_TYPE_ENEW then
        UI.open_enew(term)
    else
        error(string.format("invalid terminal type `%s`", type))
    end

    if term.type ~= TERM_TYPE_ENEW then
        P.setup_buffer_autocommands(term)
    end

    P.start(term)
    P.add(term)

    return term
end

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
        term = Term:new({ id = id, type = type })
        term = M.new(term)
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
        term = Term:new({ id = id, type = type })
        term = M.new(term)
    end

    M.last_terminal = term

    return term
end

---@param mode string
---@return Term|nil
M.send = function(mode)
    local term = nil

    if vim.o.columns == TERM_KITTY_COLUMNS then
        P.send_to_kitty(mode)
        return
    else
        term = P.send_to_nvim(mode)
    end

    return term
end

---@param cmd string?
M.exec = function(cmd)
    local term = Term:new({ id = 0, type = TERM_TYPE_ENEW, close_on_exit = false, cmd = cmd })
    M.new(term)
end

M.error = function(text)
    vim.notify(string.format("[term]: %s", text), vim.log.levels.ERROR)
end

---@param mode string
---@param cmd string|nil
---@return Term|nil
P.send_to_nvim = function(mode, cmd)
    local lines = P.get_lines_for_send(mode, cmd)

    if #lines == 0 then
        return
    end

    local term = nil
    if M.last_terminal then
        term = M.open(M.last_terminal.id, M.last_terminal.type)
    else
        M.error("there is no last terminal")
        return
    end

    for _, line in ipairs(lines) do
        line = string.format("%s\n", line)
        vim.fn.chansend(term.job_id, line)
    end

    return term
end

---@param mode string
---@param cmd string|nil
P.send_to_kitty = function(mode, cmd)
    local lines = P.get_lines_for_send(mode, cmd)

    if #lines == 0 then
        return
    end

    for _, line in ipairs(lines) do
        line = line:gsub("'", [['\'']])
        local command = string.format("%s -- '%s\n'", TERM_KITTY_CMD, line)
        vim.fn.jobstart(command)
    end
end

---@param mode TermSendMode
---@param cmd string|nil
---@return table
P.get_lines_for_send = function(mode, cmd)
    if cmd then
        return { cmd }
    end

    local lines = {}

    if mode == TERM_SEND_MODE_LINE then
        lines = { vim.api.nvim_get_current_line() }
    elseif mode == TERM_SEND_MODE_LINES then
        lines = UtilVisual.get_visual_selection_lines()
    else
        error(string.format("there is no such mode `%s`", mode))
    end

    return lines
end

---@param term Term
P.start = function(term)
    vim.validate({
        id = { term.id, "number" },
        buf_id = { term.buf_id, "number" },
    })

    local cmd = string.format("%s;#term%s", term.cmd, term.id)

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
        end,
    })
end

---@param id integer
---@param type string
---@return Term
P.get = function(id, type)
    if id == 0 and M.last_terminal then
        id = M.last_terminal.id
    end

    return M.terminals[type][id]
end

---@param type TermType
---@return integer
P.get_next_id = function(type)
    local next_id = nil

    local terminals = M.terminals[type]
    for _, terminal in pairs(terminals) do
        next_id = terminal.id + 1

        if terminals[next_id] == nil then
            return next_id
        end
    end

    return 1
end

---@param id integer
---@param type string
P.get_key = function(id, type)
    return string.format("%d_%s", id, type)
end

---@param term Term
P.add = function(term)
    M.terminals[term.type][term.id] = term
    M.last_terminal = term
    return term
end

---@param term Term
P.delete = function(term)
    M.terminals[term.type][term.id] = nil

    if term.close_on_exit and vim.api.nvim_buf_is_loaded(term.buf_id) then
        vim.api.nvim_buf_delete(term.buf_id, { force = true })
    end
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
