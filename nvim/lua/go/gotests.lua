local Gots = require("go.treesitter")
local Util = require("util.buf")
local Term = require("term")

-- TODO: race, verbose etc...
local M = {}
local P = {}

-- M coverprofile
-- go test -covermode=atomic -coverprofile=/tmp/profile.out ./...
-- go tool cover -html=/tmp/profile.out

-- M run test
-- go test -- -run="^TestPing/ping_with_some_data$"

-- M generate table driven tests
-- gotests

M.set_buf_commands = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("_test.go$") then
        vim.api.nvim_buf_create_user_command(bufnr, "GoTestFile", function(_)
            P.run_file(bufnr)
        end, {})
    end
end

P.run_file = function(bufnr)
    local tests = {}
    Gots.buf_func_names(bufnr, function(_, node, _, _)
        local funcname = vim.treesitter.get_node_text(node, bufnr, {})
        if funcname:match("^Test") then
            table.insert(tests, string.format("^%s$", funcname))
        end
    end)

    local curbufdirabspath = Util.cur_buf_dir_abs_path()
    local runregex = string.format("-run='%s'", table.concat(tests, "|"))
    local cmd = string.format("%s %s %s", P.command(), runregex, curbufdirabspath)

    Term.spawn({ cmd = cmd, bufname = cmd })
end

P.command = function()
    -- TODO: docker etc...
    local cmd = "go test"
    local args = "-v -cover -race -count=1 -benchmem -bench=."
    return string.format("%s %s", cmd, args)
end

return M
