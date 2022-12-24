local f = require("functions")
local toggleterm = require("toggleterm")

-- Git log
vim.api.nvim_create_user_command(
    "GitLog",
    function(opts)
        local range = (opts.range == 0 and opts.args) or (opts.line1 .. [[,]] .. opts.line2)
        if range == "" then
            f.git.delta([[log -p --stat --follow ]] .. [[%]])
        else
            f.git.delta([[log -p -L]] .. range .. [[:%]])
        end
    end,
    { nargs = "?", range = true }
)

-- Git log global
vim.api.nvim_create_user_command(
    "GitLogG",
    function()
        f.gitdelta([[log -p --stat]])
    end,
    { nargs = "?" }
)

-- Git show
vim.api.nvim_create_user_command(
    "GitShow",
    function(opts)
        local commit_hash = opts.args
        if commit_hash == "" then
            local cword = vim.fn.expand("<cword>")
            f.closewin()
            f.git.delta([[show -p --stat ]] .. cword)
        else
            f.git.delta([[show -p --stat ]] .. commit_hash)
        end
    end,
    { nargs = "?" }
)

-- Trim trailing whitespaces
vim.api.nvim_create_user_command(
    "TrimWhitespaces", function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
    end,
    { nargs = 0 }
)

-- Set color bar
vim.api.nvim_create_user_command(
    "SetColorColumn",
    function()
        vim.opt.colorcolumn = tostring(vim.v.count)
    end,
    { nargs = "?", count = true }
)

-- ToggleTerm commands
vim.api.nvim_create_user_command("ToggleTermSendCurrentLineNoTW",
    function(opts)
        toggleterm.send_lines_to_terminal("single_line", false, opts)
    end,
    { nargs = "?" }
)
vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionNoTW",
    function(opts)
        toggleterm.send_lines_to_terminal("visual_selection", false, opts)
    end,
    { range = true, nargs = "?" }
)

local exec = {
    filetype = {
        ["lua"] = function(opts)
            f.vterm("lua " .. opts.current_buffer)
        end,
        ["ruby"] = function(opts)
            f.vterm("ruby " .. opts.current_buffer)
        end,
        ["go"] = function(opts)
            f.vterm("go run " .. opts.current_buffer)
        end,
        ["python"] = function(opts)
            f.vterm("python3 " .. opts.current_buffer)
        end,
        ["c"] = function(opts)
            local curb = opts.current_buffer
            local cmpf = curb .. ".out"
            f.vterm([[clang ]] .. curb .. [[ -o ]] .. cmpf .. [[ && ]] .. cmpf)
        end
    },
    path = {
        ["insales/insales/spec"] = function(_)
            vim.cmd([[InsalesRspec]])
        end,
        ["insales/1c_synch/spec"] = function(_)
            vim.cmd([[SynchRspec]])
        end
    },
}

-- Run file
vim.api.nvim_create_user_command("RunCurrentFile",
    function()
        local current_buffer = vim.fn.expand("%:p")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        local opts = {
            current_buffer = current_buffer,
            filetype = filetype,
        }

        for path, func in pairs(exec.path) do
            if current_buffer:find(path) then
                func(opts)
                return
            end
        end

        local fexec = exec.filetype[filetype]
        if fexec then
            fexec(opts)
        else
            print("Can't find exec for this file - " .. current_buffer)
        end
    end,
    { nargs = "?" }
)

-- Run rspec for current file
vim.api.nvim_create_user_command(
    "InsalesRspec",
    function(opts)
        local line = opts.fargs[1]
        local path = vim.fn.expand("%:p:.")

        if line then
            f.vterm([[docker exec -it -w /home/app/code insales_insales_1]] .. [[ bundle exec rspec ]] .. path .. [[:]] .. line)
        else
            f.vterm([[docker exec -it -w /home/app/code insales_insales_1]] .. [[ bundle exec rspec ]] .. path)
        end
    end,
    { nargs = "?" }
)

-- Run rspec for current file
vim.api.nvim_create_user_command(
    "SynchRspec",
    function(opts)
        local line = opts.fargs[1]
        local path = vim.fn.expand("%:p:.:h")

        if line then
            f.vterm([[docker exec -it -w /home/app/code 1c_synch_1c_sync_1]] .. [[ bundle exec rspec ]] .. path .. [[:]] .. line)
        else
            f.vterm([[docker exec -it -w /home/app/code 1c_synch_1c_sync_1]] .. [[ bundle exec rspec ]] .. path)
        end
    end,
    { nargs = "?" }
)
