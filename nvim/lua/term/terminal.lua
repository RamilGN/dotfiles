local UtilVisual = require("util.visual")
local UI = require("term.ui")

--- @class Term
--- @field buf_id integer
--- @field bufname string
--- @field close_on_exit boolean
--- @field closer fun()
--- @field cmd string
--- @field cwd string
--- @field hidden boolean
--- @field id integer
--- @field job_id integer
--- @field open boolean
--- @field opener fun()
--- @field scroll_to_bottom boolean
--- @field startinsert boolean
--- @field type string
--- @field win_id integer
local Term = {}

--- @class TermNew
--- @field bufname? string
--- @field close_on_exit? boolean
--- @field cmd? string
--- @field cwd? string
--- @field hidden? boolean
--- @field id? integer
--- @field scroll_to_bottom? boolean
--- @field startinsert? boolean
--- @field type? string

---@type Term|nil
local LastTerminal = nil

local T = require("term.constants")

local M = {
    term = Term,
    types = T.types,
    line_modes = T.line_modes,
    augroup = T.AUGROUP,
    last_terminal = LastTerminal,
    terminals = {
        ---@type Term[]
        [T.types.FLOAT] = {},
        ---@type Term[]
        [T.types.VSPLIT] = {},
        ---@type Term[]
        [T.types.ENEW] = {},
    },
}
local P = {}

---@param termopts TermNew
---@return Term
function Term:new(termopts)
    ---@type Term
    --- @diagnostic disable-next-line: missing-fields
    local term = {
        type = termopts.type or T.types.ENEW,
        id = termopts.id or 0,
        cmd = termopts.cmd or vim.o.shell,
        cwd = termopts.cwd or vim.uv.cwd(),
        close_on_exit = termopts.close_on_exit or false,
        scroll_to_bottom = termopts.scroll_to_bottom or false,
        startinsert = termopts.startinsert or false,
        bufname = termopts.bufname,
        hidden = termopts.hidden or false,
    }

    if term.type ~= T.types.ENEW then
        term.close_on_exit = true
        term.scroll_to_bottom = true
        term.startinsert = true
        term.hidden = true
    end

    if term.id == 0 then
        term.id = P.get_next_id(term.type)
    end

    if term.bufname == nil then
        term.bufname = string.format("Term:%s:%s", term.type, term.id)
    end

    return term
end

---@param term Term
---@return Term
M.create = function(term)
    if term.type == T.types.FLOAT then
        UI.open_float(term)
    elseif term.type == T.types.VSPLIT then
        UI.open_vsplit(term)
    elseif term.type == T.types.ENEW then
        UI.open_enew(term)
    else
        error(string.format("invalid terminal type `%s`", type))
    end

    if term.type ~= T.types.ENEW then
        P.setup_buffer_autocommands(term)
    end

    P.start(term)
    P.add(term)
    P.add_time_to_bufname(term)

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
        term = M.create(term)
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
        term = M.create(term)
    end

    M.last_terminal = term

    return term
end

---@param mode string
---@param cmd string?
---@return Term|nil
M.send = function(mode, cmd)
    local term = nil

    if vim.o.columns == T.kitty.columns then
        P.send_to_kitty(mode, cmd)
        return
    else
        term = P.send_to_nvim(mode, cmd)
    end

    return term
end

---@param cmd string?
M.exec = function(cmd)
    local term = Term:new({
        id = 0,
        type = T.types.ENEW,
        close_on_exit = false,
        cmd = cmd,
        startinsert = false,
        scroll_to_bottom = false,
        hidden = false,
    })

    M.create(term)
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
        local command = string.format("%s -- '%s\n'", T.kitty.cmd, line)
        vim.fn.jobstart(command)
    end
end

---@param mode string
---@param cmd string|nil
---@return table
P.get_lines_for_send = function(mode, cmd)
    if cmd then
        return { cmd }
    end

    local lines = {}

    if mode == T.line_modes.LINE then
        local line = vim.api.nvim_get_current_line()

        if vim.bo.filetype == "ruby" then
            line = line:gsub("^%s*#", "", 1)
        end

        lines = { line }
    elseif mode == T.line_modes.LINES then
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

    local cmd = string.format("%s;#term%s;#%s", term.cmd, term.id, term.type)

    P.startinstert(term)

    term.job_id = vim.fn.termopen(cmd, {
        cwd = term.cwd,
        on_stdout = function()
            if term.scroll_to_bottom ~= true then
                return
            end

            -- Scroll to bottom.
            vim.api.nvim_buf_call(term.buf_id, function()
                local mode = vim.api.nvim_get_mode().mode

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

---@param type string
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
        group = T.AUGROUP,
        callback = function()
            P.startinstert(term)
        end,
    })
end

---@param term Term
P.add_time_to_bufname = function(term)
    vim.cmd("file " .. term.bufname .. os.date(" %H:%M:%S"))
end

---@param term Term
P.startinstert = function(term)
    if term.startinsert then
        vim.cmd("startinsert")
    end
end

return M
