local curl = require("plenary.curl")

local M = {
    roles = {
        user = "user",
        assistant = "assistant",
    },
}

M.get_chatgpt_completion = function(config, messages, process_stdout)
    local url = config.gpt.api.url
    local headers = config.gpt.api.headers
    local body = config.gpt.api.body

    curl.post(url, {
        headers = headers,
        body = vim.fn.json_encode(vim.tbl_extend("force", {
            messages = messages,
            stream = true,
        }, body)),
        stream = vim.schedule_wrap(function(_, data, _)
            process_stdout(data)
        end),
    })
end

return M
