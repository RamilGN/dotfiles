---@class Runner
local M = {}

local Util = require("util")

local Ruby = require("runner.ruby")
M.ruby = Ruby

local Lua = {}
M.lua = Lua

Lua.run = function(opts)
    Util.vterm("lua " .. opts.current_buffer)
end

local Racket = {}
M.racket = Racket

Racket.run = function(opts)
    local bin = opts.current_buffer:gsub(".rkt$", "")
    Util.vterm("raco exe " .. opts.current_buffer .. " && " .. bin)
end

local Go = {}
M.go = Go

Go.run = function(opts)
    local prefix, _ = string.match(opts.current_buffer, "(.*)(_test.go)")
    if prefix then
        local curbufdirabspath = Util.cur_buf_dir_abs_path()
        local teststr = Go.teststr(opts.selected)
        Util.vterm([[go test -v -race -cover -count=1 -benchmem -bench=.]] .. teststr .. curbufdirabspath)
    else
        Util.vterm("go run " .. opts.current_buffer)
    end
end

Go.ts_funcdecl = function()
    local current_node = vim.treesitter.get_node()
    if not current_node then
        return ""
    end

    local expr = current_node
    while expr do
        if expr:type() == "function_declaration" then
            break
        end
        expr = expr:parent()
    end
    if not expr then
        return ""
    end

    local res = (vim.treesitter.get_node_text(expr:child(1), 0))
    return res
end

Go.teststr = function(text)
    local teststr = " "
    if text then
        local _, test, _ = string.match(text, [[(func )(Test.*)(%(.*)]])
        teststr = [[ -run=]] .. test .. [[ ]]
    end

    return teststr
end

Go.yookassa_test = function(opts)
    local prefix, _ = string.match(opts.current_buffer, "(.*)(_test.go)")

    if prefix then
        local curbufrelpath = Util.get_cur_buf_dir_rel_path()
        local teststr = Go.teststr(opts.selected)
        Util.vterm(
            [[docker exec -it yookassa sh -c 'ENV_PATH=/app/configs/.test.env go test -v -cover -count=1 -benchmem -bench=.]] .. teststr .. [[/app/]] .. curbufrelpath .. [[']]
        )
    else
        print("Can't run file")
    end
end

local Python = {}
M.python = Python

Python.run = function(opts)
    Util.vterm("python3 " .. opts.current_buffer)
end

local Javascript = {}
M.javascript = Javascript

Javascript.run = function(opts)
    Util.vterm("node " .. opts.current_buffer)
end

local C = {}
M.c = C

C.run = function(opts)
    local curb = opts.current_buffer
    local cmpf = curb .. ".out"
    Util.vterm([[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf)
end

local runners = {
    filetypes = {
        ["lua"] = Lua.run,
        ["ruby"] = Ruby.run,
        ["racket"] = Racket.run,
        ["go"] = Go.run,
        ["python"] = Python.run,
        ["javascript"] = Javascript.run,
        ["c"] = C.run,
    },
    path = {
        ["insales/insales/spec"] = Ruby.insales_rspec,
        ["insales/1c_synch/spec"] = Ruby.sync1c_rspec,
        ["insales/tickets/spec"] = Ruby.tickets_rspec,
        ["insales/digital/spec"] = Ruby.digital_rspec,
        ["insales/yookassa"] = Go.yookassa_test,
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
    for path, func in pairs(runners.path) do
        if cur_buf_abs_path:find(path) then
            return func(opts)
        end
    end

    -- Execute runner by current buffer file filetype
    local runner = runners.filetypes[filetype]
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
