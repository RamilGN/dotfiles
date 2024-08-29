local config = require("myplugins.ai.config")
local M = {}

function M.setup()
    vim.fn.mkdir(config.chats_path, "p")
    vim.api.nvim_create_user_command("GptOpen", function(opts)
        if opts.range > 0 then
            vim.print(opts)
            require("myplugins.ai.chat").open_with_visual_selection()
        else
            require("myplugins.ai.chat").open_chat()
        end
    end, { range = true, nargs = "?" })

    vim.api.nvim_create_user_command("GptOpenLastChat", function(_)
        require("myplugins.ai.chat").open_last_chat()
    end, { range = false, nargs = "?" })

    vim.api.nvim_create_user_command("GptSendMessage", function(_)
        require("myplugins.ai.chat").send_message_for_cur_buf()
    end, { range = false, nargs = "?" })

    vim.api.nvim_create_user_command("GptSearch", function(_)
        require("myplugins.ai.chat").search()
    end, { range = false, nargs = "?" })

    vim.keymap.set({ "n", "v" }, "<leader>xo", ":GptOpen<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>xl", ":GptOpenLastChat<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>xm", ":GptSendMessage<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>xs", ":GptSearch<CR>")
end

return M
