require("term.constants")

local Terminal = require("term.terminal")

local M = {}
---@param opts TermOpts
local function execute_cmd(opts)
    local cmd = M.cmds[opts.cmd]

    if cmd then
        cmd(opts)
    else
        vim.notify("[term]: unknown command " .. "`" .. opts.cmd .. "`", vim.log.levels.ERROR)
    end
end

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
                term_opts.send_mode = TERM_SEND_MODE_LINE
            else
                term_opts.send_mode = TERM_SEND_MODE_LINES
            end
        end

        execute_cmd(term_opts)
    end, {
        nargs = "?",
        range = true,
        desc = "Term",
        complete = function(_, line)
            local prefix = line:match("^%s*Term (%w*[_]?%w*)") or ""
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
    open_float = function(opts)
        Terminal.open(opts.id)
    end,
    ---@param opts TermOpts
    toggle_float = function(opts)
        Terminal.toggle(opts.id)
    end,
    ---@param opts TermOpts
    send = function(opts)
        Terminal.send(opts.id, opts.send_mode)
    end,
}

return M
