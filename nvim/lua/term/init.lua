require("term.constants")
local Terminal = require("term.terminal")

local M = {}

local function execute_cmd(opts)
    if opts.cmd == "" then
        Terminal.exec()
        return
    end

    local cmd = M.cmds[opts.cmd]

    if cmd then
        cmd.exec(opts)
    else
        Terminal.error(string.format("unknown command `%s`", opts.cmd))
    end
end

M.cmds = {
    diag = {
        exec = function(_)
            vim.print(Terminal)
        end,
    },
    [TERM_CMD_SEND] = {
        exec = function(opts)
            Terminal.send(opts.send_mode)
        end,
    },
    [TERM_CMD_EXEC] = {
        exec = function(opts)
            Terminal.exec(opts.exec_cmd)
        end,
        arg = TERM_CMD_CMD_ARG,
    },
}

M.setup = function()
    for _, type in ipairs({ TERM_TYPE_FLOAT, TERM_TYPE_VSPLIT }) do
        local open_cmd = "open_" .. type
        M.cmds[open_cmd] = {
            exec = function(opts)
                Terminal.open(opts.id, type)
            end,
            arg = TERM_CMD_ID_ARG,
        }

        local toggle_cmd = "toggle_" .. type
        M.cmds[toggle_cmd] = {
            exec = function(opts)
                Terminal.toggle(opts.id, type)
            end,
            arg = TERM_CMD_ID_ARG,
        }
    end

    vim.api.nvim_create_user_command("Term", function(opts)
        local args = vim.split(opts.args, " ")

        local id = vim.v.count
        local exec_cmd = nil
        if args[2] then
            local match_id = args[2]:match(TERM_CMD_ID_ARG .. "(.*)")
            if match_id then
                id = tonumber(match_id)
            end

            -- TODO:
            local match_cmd = args[2]:match(TERM_CMD_CMD_ARG .. "(.*)")
            if match_cmd then
                exec_cmd = match_cmd
            end
        end

        local cmd = args[1]

        local term_opts = {
            id = id,
            cmd = cmd,
            exec_cmd = exec_cmd,
        }

        if cmd:match(TERM_CMD_SEND) then
            if opts.range > 0 then
                term_opts.send_mode = TERM_SEND_MODE_LINES
            else
                term_opts.send_mode = TERM_SEND_MODE_LINE
            end
        end

        execute_cmd(term_opts)
    end, {
        nargs = "?",
        range = true,
        desc = "Term",
        complete = function(_, line)
            local subcmd, arg = line:match(TERM_CMD_COMPLETE_REGEXP)
            local cmd = M.cmds[subcmd]

            if cmd ~= nil then
                if cmd.arg == nil or cmd.arg == arg then
                    return
                end

                local start_idx, _ = cmd.arg:find(arg)
                if start_idx == 1 then
                    return { cmd.arg }
                else
                    return {}
                end
            end

            subcmd = subcmd or ""
            return vim.tbl_filter(function(key)
                local start_idx, _ = key:find(subcmd)
                return start_idx == 1
            end, vim.tbl_keys(M.cmds))
        end,
    })
end

return M
