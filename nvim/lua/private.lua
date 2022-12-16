local load_private = function()
    dofile(vim.g.home_dir .. "/private/nvim.lua")
end

local status, res = pcall(load_private)

if status then
    return res
else
    print("Unexpected error while loading private configs: " .. res)
end
