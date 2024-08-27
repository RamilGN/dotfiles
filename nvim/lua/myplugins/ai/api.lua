local curl = require("plenary.curl")

local M = {
    roles = {
        user = "user",
        assistant = "assistant",
    },
}

M.get_chatgpt_completion = function(config, messages, on_delta, on_complete)
    curl.post(config.api.url, {
        headers = config.api.headers,
        body = vim.fn.json_encode({
            model = config.api.model,
            temperature = config.api.temperature,
            messages = messages,
            stream = true,
        }),
        stream = vim.schedule_wrap(function(_, data, _)
            local raw_message = string.gsub(data, "^data: ", "")
            if raw_message == "[DONE]" then
                on_complete()
            elseif string.len(data) > 6 then
                on_delta(vim.fn.json_decode(string.sub(data, 6)))
            end
        end),
    })
end

return M
