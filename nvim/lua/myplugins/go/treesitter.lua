local M = {}
local P = {}

local lang = "go"

local parse = function(query)
    return vim.treesitter.query.parse(lang, query)
end

local qs_func_names = "((function_declaration name: (identifier)@function.name))"

M.buf_func_names = function(bufnr, nodefunc)
    P.captured_buffer_nodes(parse(qs_func_names), bufnr, function(id, node, metadata, match)
        nodefunc(id, node, metadata, match)
    end)
end

P.buffer_tree = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr)
    return parser:parse()[1]
end

P.captured_buffer_nodes = function(query, bufnr, nodefunc)
    for id, node, metadata, match in query:iter_captures(P.buffer_tree(bufnr):root(), bufnr, 0, -1) do
        nodefunc(id, node, metadata, match)
    end
end

return M
