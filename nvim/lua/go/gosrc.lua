local M = {}
local P = {}

M.set_commands = function()
    vim.api.nvim_create_user_command("GoSrcGrep", function(_)
        vim.cmd("Telescope live_grep cwd=" .. P.gopath())
    end, {})

    vim.api.nvim_create_user_command("GoSrcFiles", function(_)
        vim.cmd("Telescope find_files cwd=" .. P.gopath())
    end, {})
end

P.gopath = function()
    local out = vim.fn.system("asdf which go")
    return out:gsub("/bin/go", "", 1)
end

return M
