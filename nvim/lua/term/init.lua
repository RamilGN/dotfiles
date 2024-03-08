local Util = require("util.init")

--- @class Term
--- @field id integer
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
--- @field send_mode TermSendModesLine|TermSendModesLines|nil

---@type Term[]
local T = {}
local H = {}
local M = {
    last_term_id = nil,
    terms = T,
}

---@type TermSendModesLine
local TermSendModeLine = { value = "line" }
---@type TermSendModesLines
local TermSendModeLines = { value = "lines" }

local AUGROUP = vim.api.nvim_create_augroup("Term", { clear = true })

M.setup = function()
    vim.api.nvim_create_user_command("Term", function(opts)
        local id = vim.v.count
        local cmd = vim.trim(opts.args or "")

        --- @class TermOpts
        local term_opts = {
            id = id,
            cmd = cmd,
        }

        if cmd == "send" then
            if opts.range > 0 then
                term_opts.send_mode = TermSendModeLines
            else
                term_opts.send_mode = TermSendModeLine
            end
        end

        H.execute_cmd(term_opts)
    end, {
        nargs = "?",
        range = true,
        desc = "Term",
        complete = function(_, line)
            local prefix = line:match("^%s*Term (%w*)") or ""
            if M.cmds[prefix] ~= nil then
                return
            end

            return vim.tbl_filter(function(key)
                local start_idx, _ = key:find(prefix)
                return start_idx == 1
            end, vim.tbl_keys(M.cmds))
        end,
    })
end

M.cmds = {
    ---@param opts TermOpts
    toggle = function(opts)
        M.toggle(opts.id)
    end,
    ---@param opts TermOpts
    send = function(opts)
        M.send(opts.id, opts.send_mode.value)
    end,
}

---@param id integer
---@return Term
M.toggle = function(id)
    id = H.get_term_id(id)

    local term = T[id]
    if term and term.open then
        term.closer()
    elseif term then
        term.opener()
    else
        term = H.new_term(id)
    end

    M.last_term_id = term.id

    return term
end

---@param id integer
---@return Term
M.open = function(id)
    id = H.get_term_id(id)

    local term = T[id]
    if term and term.open then
        return term
    elseif term then
        term.opener()
    else
        term = H.new_term(id)
    end

    M.last_term_id = term.id

    return term
end

---@param id integer
---@param mode string
---@return Term|nil
M.send = function(id, mode)
    local lines = {}

    if mode == TermSendModeLine.value then
        local line = vim.api.nvim_get_current_line()
        lines = { line .. "\n" }
    elseif mode == TermSendModeLines.value then
        lines = Util.get_visual_selection_lines()
    end

    if #lines == 0 then
        return
    end

    local term = M.open(id)

    for _, line in ipairs(lines) do
        vim.fn.chansend(term.job_id, line)
    end

    return term
end

--- @return Term
H.new_term = function(id)
    local term = { id = id }

    H.open(term)
    H.setup_highlighs(term)
    H.setup_buffer_autocommands(term)
    H.start(term)
    H.add_to_terms(term)

    return term
end

---@param term Term
H.start = function(term)
    local shell = vim.o.shell
    local cmd = string.format("%s;#term%s", shell, term.id)

    vim.cmd("startinsert")

    term.job_id = vim.fn.termopen(cmd, {
        cwd = vim.loop.cwd(),
        on_stdout = function()
            local mode = vim.api.nvim_get_mode().mode

            if mode == "n" or mode == "nt" then
                vim.cmd("normal! G")
            end
        end,
        on_exit = function()
            T[term.id] = nil
            vim.api.nvim_buf_delete(term.buf_id, { force = true })
        end,
    })
end

---@param term Term
H.open = function(term)
    H.open_float(term)
    term.opener = function()
        H.open_float(term)
    end
end

---@param term Term
H.open_float = function(term)
    local buf_id = term.buf_id

    if buf_id == nil or not vim.api.nvim_buf_is_valid(term.buf_id) then
        buf_id = vim.api.nvim_create_buf(false, false)
    end

    local win_id = vim.api.nvim_open_win(buf_id, true, H.get_float_config())

    term.buf_id = buf_id
    term.win_id = win_id
    term.open = true
    term.closer = function()
        term.open = false
        vim.api.nvim_win_close(term.win_id, true)
    end

    return buf_id, win_id
end

H.get_float_config = function()
    local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 20)))
    local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))
    local row = math.ceil(vim.o.lines - height) * 0.5 - 1
    local col = math.ceil(vim.o.columns - width) * 0.5 - 1

    local float_config = {
        row = row,
        col = col,
        relative = "editor",
        style = "minimal",
        width = width,
        height = height,
        border = "single",
    }

    return float_config
end

---@param term Term
H.setup_buffer_autocommands = function(term)
    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = term.buf_id,
        group = AUGROUP,
        callback = term.closer,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        buffer = term.buf_id,
        group = AUGROUP,
        callback = function()
            vim.cmd("startinsert")
        end,
    })
end

---@param term Term
H.setup_highlighs = function(term)
    vim.wo[term.win_id].winhighlight = "FloatBorder:TermBorder,NormalFloat:TermNormalFloat"
end

---@param term Term
H.add_to_terms = function(term)
    T[term.id] = term
end

---@param id integer
---@return integer
H.get_term_id = function(id)
    if id == 0 and M.last_term_id then
        id = M.last_term_id
    elseif id == 0 then
        id = 1
    end

    return id
end

---@param opts TermOpts
H.execute_cmd = function(opts)
    local cmd = M.cmds[opts.cmd]

    if cmd then
        cmd(opts)
    else
        vim.notify("[term]: unknown command " .. "`" .. opts.cmd .. "`", vim.log.levels.ERROR)
    end
end

return M
