local api = require("myplugins.gpt.api")
local config = require("myplugins.gpt.config")

local M = {}
local P = {
    user = "# User",
    assistant = "# Assistant",
    last_chat = config.chats_path .. "/last.md",
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

M.send_message_for_cur_buf = function()
    local bufnr = vim.api.nvim_get_current_buf()
    P.send_message(bufnr)
end

P.send_message = function(bufnr)
    local current_line = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, current_line, current_line, false, { "", P.assistant, "", "..." })

    current_line = vim.api.nvim_buf_line_count(bufnr) - 1
    local current_line_contents = ""
    local on_delta = function(response)
        if response and response.choices and response.choices[1] and response.choices[1].delta and response.choices[1].delta.content then
            local delta = response.choices[1].delta.content
            if delta == "\n" then
                vim.api.nvim_buf_set_lines(bufnr, current_line, current_line, false, { current_line_contents })
                current_line = current_line + 1
                current_line_contents = ""
            elseif delta:match("\n") then
                for line in delta:gmatch("[^\n]+") do
                    vim.api.nvim_buf_set_lines(bufnr, current_line, current_line, false, { current_line_contents .. line })
                    current_line = current_line + 1
                    current_line_contents = ""
                end
            elseif delta ~= nil then
                current_line_contents = current_line_contents .. delta
            end
        end
    end

    local on_complete = function()
        vim.api.nvim_buf_set_lines(bufnr, current_line, current_line + 1, false, { current_line_contents, "", P.user, "" })
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        vim.cmd("w! " .. bufname)
    end

    local messages = P.parse_markdown()
    api.get_chatgpt_completion(config, messages, on_delta, on_complete)
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

    local lines = vim.split(text, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)

    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(bufnr), 0 })
    vim.cmd("w!" .. chatname)

    if vim.fn.filereadable(P.last_chat) == 1 then
        os.remove(P.last_chat)
    end
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

return M
