local M = {}

M.setup = function()
    require("term.constants")

    local Terminal = require("term.terminal")

    ---@param opts TermOpts
    local function execute_cmd(opts)
        if opts.cmd == "" then
            Terminal.new(TERM_TYPE_ENEW)
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
            arg = TERM_CMD_CMD_ARG,
        },
    }

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
        if args[2] then
            id = tonumber(vim.split(args[2], "=")[2]) or 0
        end

        local cmd = args[1]

        --- @class TermOpts
        local term_opts = {
            id = id,
            cmd = cmd,
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