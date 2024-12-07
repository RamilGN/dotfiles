local api = require("myplugins.ai.api")
local config = require("myplugins.ai.config")

local M = {}
local P = {
    user = "# User",
    assistant = "# Assistant",
    last_chat = config.chats_path .. "/last.md",
    loading = "...",
}
P.user_regex = "^" .. P.user .. "$"
P.assistant_regex = "^" .. P.assistant .. "$"

M.open_last_chat = function()
    if vim.fn.filereadable(P.last_chat) == 1 then
        vim.cmd("e " .. P.last_chat)
    else
        M.open_chat()
    end
end

M.open_chat = function()
    local chat_buffer = P.open_chat_with_text(string.format("%s\n", P.user))
    return chat_buffer
end

M.open_with_visual_selection = function()
    local text = require("myplugins.util.visual").get_visual_selection_text()
    local chat_buffer = P.open_chat_with_text(string.format("%s\n\n```%s\n%s\n```\n", P.user, vim.bo.filetype, text))
    return chat_buffer
end

M.send_message_for_cur_buf = function()
    local bufnr = vim.api.nvim_get_current_buf()
    P.send_message(bufnr)
end

M.search = function()
    local telescope = require("telescope.builtin")
    telescope.live_grep({ cwd = config.chats_path })
end

P.process_stdout = function(bufnr)
    return function(data)
        local message = string.match(data, "^data: (.*)")

        if message == nil then
            return
        elseif message == "[DONE]" then
            local current_line = vim.api.nvim_buf_line_count(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            vim.api.nvim_buf_set_lines(bufnr, current_line, current_line + 1, false, { "", P.user, "" })
            vim.cmd("silent! w! " .. bufname)
        else
            message = vim.fn.json_decode(message)
            if message and message.choices and message.choices[1] and message.choices[1].delta and message.choices[1].delta.content then
                local current_line = vim.api.nvim_buf_line_count(bufnr)
                local current_line_content = vim.api.nvim_buf_get_lines(bufnr, current_line - 1, current_line, false)[1]
                if current_line_content == P.loading then
                    current_line_content = ""
                end

                local content = message.choices[1].delta.content
                local lines = vim.split(content, "\n")
                lines[1] = current_line_content .. lines[1]

                vim.api.nvim_buf_set_lines(bufnr, current_line - 1, (current_line - 1 + #lines), false, lines)
            end
        end
    end
end

P.send_message = function(bufnr)
    local messages = P.parse_markdown()
    local current_line = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, current_line, current_line, false, { "", P.assistant, "", P.loading })
    api.get_chatgpt_completion(config, messages, P.process_stdout(bufnr))
end

P.get_chat_name = function()
    return config.chats_path .. os.date("/%y%m%d%H%M%S.md")
end

P.open_chat_with_text = function(text)
    local bufnr = vim.api.nvim_create_buf(true, false)
    local chatname = P.get_chat_name()

    vim.api.nvim_buf_set_name(bufnr, chatname)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_set_current_buf(bufnr)

    P.set_buf_keymaps(bufnr)

    local lines = vim.split(text, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)

    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(bufnr), 0 })
    vim.cmd("w!" .. chatname)

    os.remove(P.last_chat)
    vim.uv.fs_symlink(chatname, P.last_chat)

    return bufnr
end

P.parse_markdown = function()
    local messages = {}
    local current_entry = nil
    local buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

    for _, line in ipairs(lines) do
        local role = api.roles.user

        if line:match(P.user_regex) then
            role = api.roles.user

            if current_entry then
                table.insert(messages, current_entry)
            end
            current_entry = { role = role, content = "" }
        elseif line:match(P.assistant_regex) then
            role = api.roles.assistant

            if current_entry then
                table.insert(messages, current_entry)
            end
            current_entry = { role = role, content = "" }
        elseif current_entry then
            if line ~= "" then
                if current_entry.content == "" then
                    current_entry.content = line
                else
                    current_entry.content = current_entry.content .. "\n" .. line
                end
            end
        end
    end

    if current_entry then
        table.insert(messages, current_entry)
    end

    return messages
end

P.set_buf_keymaps = function(bufnr)
    vim.keymap.set({ "n", "v" }, "<leader>xm", ":GptSendMessage<CR>", { buffer = bufnr, desc = "Send messages for current chat" })
end

return M
