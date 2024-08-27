local M = {
    chats_path = vim.fn.stdpath("data") .. "/gpt/chats",
    api = {
        model = "gpt-4o-mini",
        temperature = 1,
        url = "https://api.openai.com/v1/chat/completions",
        headers = {
            Authorization = "Bearer " .. (vim.env.OPENAI_API_KEY or ""),
            Content_Type = "application/json",
        },
    },
}

return M
