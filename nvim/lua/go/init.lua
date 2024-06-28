local M = { group = nil }
local P = {}

M.setup = function()
    P.create_group()
    P.create_init_autocmd()
end

P.create_group = function()
    M.group = vim.api.nvim_create_augroup("GoInit", { clear = true })
end

P.create_init_autocmd = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = M.group,
        pattern = "*.go",
        callback = function(initopts)
            P.set_buf_keymaps(initopts)
            P.set_buf_commands(initopts)
            P.set_buf_autocommands(initopts)
        end,
    })
end

P.set_buf_keymaps = function(initopts)
    vim.keymap.set("n", "<leader>ng", function()
        vim.cmd("e ~/workspace/scratch/main.go")
    end, { buffer = initopts.buf, desc = "Scratch" })
end

P.set_buf_commands = function(initopts)
    vim.api.nvim_buf_create_user_command(initopts.buf, "GoSrcGrep", function(opts)
        vim.cmd("Telescope live_grep cwd=" .. P.gopath())
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoSrcFiles", function(opts)
        vim.cmd("Telescope find_files cwd=" .. P.gopath())
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoTagsAdd", function(opts)
        local args = { "-add-tags", P.gomodifytags_default_tag(opts) }
        P.gomodifytags(initopts.buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoTagsRemove", function(opts)
        local args = { "-remove-tags", P.gomodifytags_default_tag(opts) }
        P.gomodifytags(initopts.buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoTagsClear", function(opts)
        local args = { "-clear-tags" }
        P.gomodifytags(initopts.buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoTagsOptionsAdd", function(opts)
        local args = { "-add-options", P.gomodifytags_default_tag_and_option(opts) }
        P.gomodifytags(initopts.buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoTagsOptionsRemove", function(opts)
        local args = { "-remove-options", P.gomodifytags_default_tag_and_option(opts) }
        P.gomodifytags(initopts.buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })

    vim.api.nvim_buf_create_user_command(initopts.buf, "GoTagsOptionsClear", function(opts)
        local args = { "-clear-options" }
        P.gomodifytags(initopts.buf, opts.line1, opts.line2, args)
    end, { nargs = "*", range = true })
end

P.set_buf_autocommands = function(initopts)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("GoFormatOnSave_" .. initopts.buf, { clear = true }),
        buffer = initopts.buf,
        callback = function(_)
            require("conform").format({ lsp_fallback = true })
        end,
    })
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

P.gopath = function()
    local out = vim.fn.system("asdf which go")
    return out:gsub("/bin/go", "", 1)
end

return M
