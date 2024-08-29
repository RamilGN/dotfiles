local M = {
    chats_path = vim.fn.stdpath("data") .. "/ai/chats",
    gpt = {
        api = {
            url = "https://api.openai.com/v1/chat/completions",
            body = {
                model = "gpt-4-turbo",
                temperature = 1,
                max_tokens = 2048,
            },
            headers = {
                Authorization = "Bearer " .. (vim.env.OPENAI_API_KEY or ""),
                Content_Type = "application/json",
            },
        },
    },
    claude = {
        api = {
            body = {
                model = "claude-3-5-sonnet-20240620",
                temperature = 1,
                max_tokens = 2048,
            },
            headers = {
                ["x-api-key"] = (vim.env.CLAUDE_API_KEY or ""),
                ["anthropic-version"] = "2023-06-01",
                Content_Type = "application/json",
            },
        },
    },
}

return M
