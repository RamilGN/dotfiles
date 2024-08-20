local M = {}
local P = {}

M.set_buf_commands = function(buf)
    vim.api.nvim_buf_create_user_command(buf, "GoTagsAdd", function(opts)
        local args = { "-add-tags", P.gomodifytags_default_tag(opts) }
        P.gomodifytags(buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(buf, "GoTagsRemove", function(opts)
        local args = { "-remove-tags", P.gomodifytags_default_tag(opts) }
        P.gomodifytags(buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(buf, "GoTagsClear", function(opts)
        local args = { "-clear-tags" }
        P.gomodifytags(buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(buf, "GoTagsOptionsAdd", function(opts)
        local args = { "-add-options", P.gomodifytags_default_tag_and_option(opts) }
        P.gomodifytags(buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(buf, "GoTagsOptionsRemove", function(opts)
        local args = { "-remove-options", P.gomodifytags_default_tag_and_option(opts) }
        P.gomodifytags(buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(buf, "GoTagsOptionsClear", function(opts)
        local args = { "-clear-options" }
        P.gomodifytags(buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })
end

P.gomodifytags = function(buf, line1, line2, args)
    local bufname = vim.api.nvim_buf_get_name(buf)

    local cmd = {
        "gomodifytags",
        "-format",
        "json",
        "-file",
        bufname,
        "-line",
        string.format("%s,%s", line1, line2),
    }

    for _, value in ipairs(args) do
        table.insert(cmd, value)
    end

    local out = vim.fn.system(cmd)
    if vim.v.shell_error == 0 then
        local jsonout = vim.json.decode(out)
        vim.api.nvim_buf_set_lines(buf, jsonout["start"] - 1, jsonout["end"], true, jsonout["lines"])
        vim.cmd("w!")
    else
        vim.notify(out, vim.log.levels.ERROR)
    end
end

P.gomodifytags_default_tag = function(opts)
    local tag = opts.args

    if opts.args == "" then
        tag = "json"
    end

    return tag
end

P.gomodifytags_default_tag_and_option = function(opts)
    local tag_and_option = opts.args

    if tag_and_option == "" then
        local tag = P.gomodifytags_default_tag(opts)
        tag_and_option = string.format("%s=%s", tag, "omitempty")
    end

    return tag_and_option
end

return M
