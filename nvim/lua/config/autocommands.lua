return {
    setup = function()
        local function augroup(name)
            return vim.api.nvim_create_augroup(name, { clear = true })
        end

        -- Turn off input method outside insert mode.
        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                vim.opt.iminsert = 0
            end,
            pattern = "*",
            group = augroup("input_mode")
        })

        -- Turn off comments auto-insert.
        vim.api.nvim_create_autocmd("BufWinEnter", {
            callback = function()
                vim.opt.formatoptions:remove({ "c", "r", "o" })
            end,
            pattern = "*",
            group = augroup("format_options")
        })

        -- Highlight yanking text.
        vim.api.nvim_create_autocmd("TextYankPost", {
            callback = function()
                vim.highlight.on_yank()
            end,
            pattern = "*",
            group = augroup("yank_highlight"),
        })

        -- Trim trailing whitespaces.
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup("trimspaces"),
            pattern = "*",
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                if vim.fn.getbufvar(buf, "&modifiable") == 0 then
                    return
                end

                vim.cmd([[%s/\s\+$//e]])
            end
            ,
        })

        -- Auto create dir when saving a file, in case some intermediate directory does not exist.
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = augroup("auto_create_dir"),
            callback = function(event)
                if event.match:match("^%w%w+://") then
                    return
                end
                local file = vim.loop.fs_realpath(event.match) or event.match
                vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end,
        })

        -- Go to last loc when opening a buffer.
        vim.api.nvim_create_autocmd("BufReadPost", {
            group = augroup("last_loc"),
            callback = function()
                local exclude = { "gitcommit" }
                local buf = vim.api.nvim_get_current_buf()
                if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
                    return
                end
                local mark = vim.api.nvim_buf_get_mark(buf, '"')
                local lcount = vim.api.nvim_buf_line_count(buf)
                if mark[1] > 0 and mark[1] <= lcount then
                    pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
            end,
        })

        -- Check if we need to reload the file when it changed.
        vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
            group = augroup("checktime"),
            command = "checktime",
        })
    end
}
