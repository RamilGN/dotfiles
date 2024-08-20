local Gots = require("myplugins.go.treesitter")
local Util = require("myplugins.util.buf")
local Term = require("myplugins.term.init")

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

-- plus args -race -benchmem -bench=.

M.set_buf_commands = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("_test.go$") then
        vim.api.nvim_buf_create_user_command(bufnr, "GoTestFile", function(_)
            M.run_file(bufnr)
        end, {})
    end
end

M.run_file = function(bufnr)
    local tests = {}
    Gots.buf_func_names(bufnr, function(_, node, _, _)
        local funcname = vim.treesitter.get_node_text(node, bufnr, {})
        if funcname:match("^Test") then
            table.insert(tests, string.format("^%s$", funcname))
        end
    end)

    local curbufdirabspath = Util.cur_buf_dir_abs_path()
    local runregex = string.format('-run="%s"', table.concat(tests, "|"))
    local cmd = ""
    if curbufdirabspath:find("insales/yookassa") then
        curbufdirabspath = string.format("/app/%s", Util.get_cur_buf_dir_rel_path())
        local args = string.format("-v -cover -count=1 %s", runregex)
        local gocmd = string.format("ENV_PATH=/app/configs/.test.env go test %s %s", args, curbufdirabspath)
        cmd = string.format("docker exec -it yookassa sh -c '%s'", gocmd)
    else
        local args = string.format("-v -cover -count=1 %s", runregex)
        cmd = string.format("go test %s %s", args, curbufdirabspath)
    end

    Term.spawn({ cmd = cmd, bufname = cmd })
end

return M
