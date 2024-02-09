local M = {}

local Util = require("util")

M.run = function(opts)
    Util.vterm("ruby " .. opts.current_buffer)
end

M.get_cur_spec = function(opts)
    local line = nil
    if opts.range > 0 and opts.line1 == opts.line2 then
        line = opts.line1
    else
        line = opts.fargs[1]
    end

    local spec = vim.fn.expand("%:p:.")
    if line then
        spec = spec .. [[:]] .. line
    end

    return spec
end

M.insales_rspec = function(opts)
    local spec = M.get_cur_spec(opts.cmd_args)
    Util.vterm([[docker exec -it -w /home/app/code insales-insales-1 bin/spring rspec ]] .. spec)
end

M.sync1c_rspec = function(opts)
    local spec = M.get_cur_spec(opts.cmd_args)
    Util.vterm([[docker exec -it -w /home/app/code 1c_synch-1c_sync-1 bundle exec rspec ]] .. spec)
end

M.tickets_rspec = function(opts)
    local spec = M.get_cur_spec(opts.cmd_args)
    Util.vterm([[docker exec -it -w /tickets tickets-backend-1 bin/spring rspec ]] .. spec)
end

M.digital_rspec = function(opts)
    local spec = M.get_cur_spec(opts.cmd_args)
    Util.vterm([[docker exec -it -w /app digital-backend-1 bundle exec rspec ]] .. spec)
end

return M
