local T = {}
local H = {}
local M = {
    last_term_id = nil,
    terms = T,
}

local AUGROUP = vim.api.nvim_create_augroup("Term", { clear = true })

M.setup = function()
    vim.api.nvim_create_user_command("Term", function(_)
        local id = vim.v.count
        local term_opts = { id = id }
        M.toggle(term_opts)
    end, {
        nargs = "?",
        count = true,
        desc = "Term",
    })
end

M.toggle = function(opts)
    local id = opts.id

    if id == 0 and M.last_term_id then
        id = M.last_term_id
    elseif id == 0 then
        id = 1
    end

    local term = T[id]
    if term and term.open then
        term.closer()
    elseif term then
        term.opener(term)
    else
        term = H.new_term(id)
    end

    M.last_term_id = term.id
end

H.new_term = function(id)
    local term = {
        id = id,
        open = nil,
        opener = nil,
        closer = nil,
        buf_id = nil,
        win_id = nil,
    }

    H.open(term)
    H.setup_highlighs(term)
    H.setup_buffer_autocommands(term)
    H.start(term)
    H.add_to_terms(term)

    return term
end

H.start = function(term)
    local shell = vim.o.shell
    local cmd = string.format("%s;#term%s", shell, term.id)

    vim.cmd("startinsert")
    vim.fn.termopen(cmd, {
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

H.open = function(term)
    H.open_float(term)
    term.opener = H.open_float
end

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

H.setup_highlighs = function(term)
    vim.wo[term.win_id].winhighlight = "FloatBorder:TermBorder,NormalFloat:TermNormalFloat"
end

H.add_to_terms = function(term)
    T[term.id] = term
end

return M
