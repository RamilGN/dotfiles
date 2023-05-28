local M = {}

M.ts_funcdecl = function()
    local current_node = vim.treesitter.get_node()
    if not current_node then return "" end

    local expr = current_node
    while expr do
        if expr:type() == "function_declaration" then
            break
        end
        expr = expr:parent()
    end
    if not expr then return "" end

    local res = (vim.treesitter.get_node_text(expr:child(1), 0))
    return res
end

return M
