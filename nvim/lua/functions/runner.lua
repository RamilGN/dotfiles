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
                local curbufdirabspath = v.cur_buf_dir_abs_path()
                local teststr = " "
                if opts.selected then
                    teststr = [[ -run=]] .. opts.selected .. [[ ]]
                end
                v.vterm([[go test -race -bench=. -cover]] .. teststr .. curbufdirabspath)
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
        end,
        ["insales/tickets/spec"] = function(opts)
            local spec = r.get_cur_spec(opts.cmd_args)
            r.tickets_rspec(spec)
        end,
        -- TODO: create go runner
        ["insales/yookassa"] = function(opts)
            local prefix, _ = string.match(opts.current_buffer, "(.*)(_test.go)")
            if prefix then
                local curbufrelpath = v.get_cur_buf_dir_rel_path()
                local teststr = " "
                if opts.selected then
                    teststr = [[ -run=]] .. opts.selected .. [[ ]]
                end
                v.vterm([[docker exec -it yookassa sh -c 'ENV_PATH=/app/configs/.test.env go test -bench=. -cover]] .. teststr .. [[/app/]] .. curbufrelpath .. [[']])
            else
                local curbufrelpath = v.get_cur_buf_rel_path()
                v.vterm([[docker exec -it yookassa go run .. /app/]] .. curbufrelpath)
            end
        end
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
