local M = {}

M.insales = function(path)
    local line = opts.fargs[1]
                 vim.fn.expand("%:p:.:h")
    local path = vim.fn.expand("%:p:.")
    f.vim.vterm([[docker exec -it -w /home/app/code insales_insales_1 bundle exec rspec ]] .. path)
end

M.sync1c = function()
end

return M
