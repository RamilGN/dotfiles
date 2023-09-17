local v = require("functions.vim")
local r = require("functions.ruby")
local g = require("functions.go")

local M = {}
local exec = {
    filetype = {
        ["lua"] = function(opts) v.vterm("lua " .. opts.current_buffer) end,
        ["ruby"] = r.ruby,
        ["go"] = g.go,
        ["python"] = function(opts) v.vterm("python3 " .. opts.current_buffer) end,
        ["javascript"] = function(opts) v.vterm("node " .. opts.current_buffer) end,
        ["c"] = function(opts)
            local curb = opts.current_buffer
            local cmpf = curb .. ".out"
            v.vterm([[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf)
        end
    },
    path = {
        ["insales/insales/spec"] = r.insales_rspec,
        ["insales/1c_synch/spec"] = r.sync1c_rspec,
        ["insales/tickets/spec"] = r.tickets_rspec,
        ["insales/yookassa"] = g.yookassa_test,
    },
}

M.run = function(cmd_args)
    local current_buffer = vim.fn.expand("%:p")
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    local text = nil
    if cmd_args.range > 0 then
        text = v.get_visual_selection_v2()
    end

    local opts = {
        current_buffer = current_buffer,
        cmd_args = cmd_args,
        selected = text,
    }

    -- Find exec by current_buffer path
    for path, func in pairs(exec.path) do
        if current_buffer:find(path) then
            return func(opts)
        end
    end

    -- Find ceratin exec by key
    local fexec = exec.filetype[filetype]
    if fexec then
        return fexec(opts)
    else
        print("Can't find exec for this file - " .. current_buffer)
    end
end

return M
