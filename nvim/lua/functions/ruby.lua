local v = require("functions.vim")

local M = {}

M.get_cur_spec = function(opts)
    local line = opts.fargs[1]
    local spec = vim.fn.expand("%:p:.")
    if line then
        spec = " " .. spec .. [[:]] .. line
    end
    return spec
end

M.insales_rspec = function(specs)
    v.vterm([[docker exec -it -w /home/app/code insales_insales_1 bundle exec rspec ]] .. specs)
end

M.sync1c_rspec = function(specs)
    v.vterm([[docker exec -it -w /home/app/code 1c_synch_1c_sync_1 bundle exec rspec ]] .. specs)
end

return M