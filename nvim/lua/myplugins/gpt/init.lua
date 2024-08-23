local config = require("myplugins.gpt.config")
local M = {}

function M.setup()
    vim.fn.mkdir(config.chats_path, "p")
    vim.api.nvim_create_user_command("GptOpen", function(opts)
        if opts.range > 0 then
            require("myplugins.gpt.chat").open_chat_with_visual_selection()
        else
            require("myplugins.gpt.chat").open_chat()
        end
    end, { range = true, nargs = "?" })

    vim.api.nvim_create_user_command("GptOpenLastChat", function(_)
        require("myplugins.gpt.chat").open_last_chat()
    end, { range = true, nargs = "?" })

    vim.api.nvim_create_user_command("GptSendMessage", function(_)
        require("myplugins.gpt.chat").send_message_for_cur_buf()
    end, { range = true, nargs = "?" })

    vim.keymap.set({ "n", "v" }, "<leader>xo", ":GptOpen<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>xl", ":GptOpenLastChat<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>xm", ":GptSendMessage<CR>")
end

return M
