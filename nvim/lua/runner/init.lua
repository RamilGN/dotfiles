---@class Runner
local M = {
    ruby = require("runner.ruby"),
    go = require("runner.go"),
    lua = require("runner.lua"),
    racket = require("runner.racket"),
    python = require("runner.python"),
    javascript = require("runner.javascript"),
    c = require("runner.c"),
}

local Util = require("util.init")

local runners = {
    filetypes_to_runner = {
        ["lua"] = M.lua.run,
        ["ruby"] = M.ruby.run,
        ["racket"] = M.racket.run,
        ["go"] = M.go.run,
        ["python"] = M.python.run,
        ["javascript"] = M.javascript.run,
        ["c"] = M.c.run,
    },
    paths_to_runner = {
        ["insales/insales/spec"] = M.ruby.insales_rspec,
        ["insales/1c_synch/spec"] = M.ruby.sync1c_rspec,
        ["insales/tickets/spec"] = M.ruby.tickets_rspec,
        ["insales/digital/spec"] = M.ruby.digital_rspec,
        ["insales/yookassa"] = M.go.yookassa_test,
    },
}

M.run = function(cmd_args)
    local cur_buf_abs_path = vim.fn.expand("%:p")
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    local text = nil
    if cmd_args.range > 0 then
        text = Util.get_visual_selection_text()
    end

    local opts = {
        current_buffer = cur_buf_abs_path,
        cmd_args = cmd_args,
        selected = text,
    }

    -- Execute runner by current buffer file path
    for path, func in pairs(runners.paths_to_runner) do
        if cur_buf_abs_path:find(path) then
            return func(opts)
        end
    end

    -- Execute runner by current buffer file filetype
    local runner = runners.filetypes_to_runner[filetype]
    if runner then
        return runner(opts)
    else
        vim.notify("[runner]: can't find runner for this file - " .. cur_buf_abs_path, vim.log.levels.ERROR)
    end
end

M.setup = function()
    -- Run current file
    vim.api.nvim_create_user_command("Run", function(opts)
        M.run(opts)
    end, { nargs = "*", range = true })
end

return M
