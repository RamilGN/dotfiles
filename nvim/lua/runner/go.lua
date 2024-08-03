local Term = require("term")
local Util = require("util.buf")

local M = {}

M.teststr = function(text)
    local teststr = " "
    if text then
        local _, test, _ = string.match(text, [[(func )(Test.*)(%(.*)]])
        teststr = [[ -run=]] .. test .. [[ ]]
    end

    return teststr
end

M.ts_funcdecl = function()
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

M.run = function(opts)
    local cmd = ""
    local curbufdirabspath = Util.cur_buf_dir_abs_path()

    local prefix, _ = string.match(opts.current_buffer, "(.*)(_test.go)")
    if prefix then
        local teststr = M.teststr(opts.selected)
        cmd = [[go test -v -race -cover -count=1 -benchmem -bench=.]] .. teststr .. curbufdirabspath
    else
        cmd = "go run " .. opts.current_buffer
    end

    Term.spawn({ cmd = cmd, cwd = curbufdirabspath, bufname = cmd })
end

M.yookassa_test = function(opts)
    local prefix, _ = string.match(opts.current_buffer, "(.*)(_test.go)")

    if prefix then
        require("go.gotests").run_file(opts.bufnr)
    else
        print("Can't run file")
    end
end

return M
