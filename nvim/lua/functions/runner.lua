local v = require("functions.vim")
local r = require("functions.ruby")

local M = {}
local exec = {
    filetype = {
        ["lua"] = function(opts)
            v.vterm("lua " .. opts.current_buffer)
        end,
        ["ruby"] = function(opts)
            v.vterm("ruby " .. opts.current_buffer)
        end,
        ["go"] = function(opts)
            local prefix, _ = string.match(opts.current_buffer, "(.*)(_test.go)")
            if prefix then
                local src = prefix .. ".go"
                v.vterm("go test " .. src .. " " .. opts.current_buffer)
            else
                v.vterm("go run " .. opts.current_buffer)
            end
        end,
        ["python"] = function(opts)
            v.vterm("python3 " .. opts.current_buffer)
        end,
        ["c"] = function(opts)
            local curb = opts.current_buffer
            local cmpf = curb .. ".out"
            v.vterm([[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf)
        end
    },
    path = {
        ["insales/insales/spec"] = function(opts)
            local spec = r.get_cur_spec(opts.cmd_args)
            r.insales_rspec(spec)
        end,
        ["insales/1c_synch/spec"] = function(opts)
            local spec = r.get_cur_spec(opts.cmd_args)
            r.sync1c_rspec(spec)
        end
    },
}

M.run = function(cmd_args)
    local current_buffer = vim.fn.expand("%:p")
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    local opts = {
        current_buffer = current_buffer,
        cmd_args = cmd_args
    }

    -- Find exec by current_buffer path
    for path, func in pairs(exec.path) do
        if current_buffer:find(path) then
            func(opts)
            return
        end
    end

    -- Find ceratin exec by key
    local fexec = exec.filetype[filetype]
    if fexec then
        fexec(opts)
    else
        print("Can't find exec for this file - " .. current_buffer)
    end
end

return M
