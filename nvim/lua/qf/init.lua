local M = { group = nil }
local P = {}

M.setup = function()
    P.create_group()
    P.create_init_autocmd()
end

P.create_group = function()
    M.group = vim.api.nvim_create_augroup("QFedit", { clear = true })
end

P.create_init_autocmd = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = M.qf_group,
        pattern = "quickfix",
        -- nested = true,
        callback = function(opts)
            P.create_write_autocmd(opts)
            -- vim.cmd("write! quickfix-" .. vim.fn.bufnr("%"))
        end,
    })

    P.write_autocmd()
end

P.create_write_autocmd = function(initopts)
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        group = M.qf_group,
        buffer = initopts.buf,
        callback = function(writeopts)
            vim.print("write! on buffer" .. writeopts.buf)
        end,
    })
end

-- function OnWrite()
--     if not vim.bo.modified then
--         return
--     end
--
--     if vim.tbl_isempty(vim.g.qfBufferLines) then
--         vim.api.nvim_err_writeln("quickfix_reflector not initialized in this buffer (empty). Try :copen again.")
--         return
--     end
--
--     local qfBufferLines = vim.deepcopy(vim.g.qfBufferLines)
--     local isLocationList = #vim.fn.getloclist(0) > 0
--     local qfWinNumber = vim.fn.winnr()
--
--     -- Get quickfix entries and create search patterns to find them again after they have been changed in the quickfix buffer
--     local qfList = getQfOrLocationList(isLocationList, qfWinNumber)
--     local changes = {}
--     local entryIndex = 0
--     for _, entry in ipairs(qfList) do
--         -- Now find the line in the buffer using the quickfix description.
--         -- Then use that line to create a pattern without that text so we can find the entry again after it has changed
--         -- Vim sometimes does not display the full line if it's very long, so we compare the end of the line instead
--         local endOfChange = 0
--         local endOfChangeInChangedVersion = 0
--         for n = 0, math.max(#entry.text, #qfBufferLines[entry.lnum]) do
--             if entry.text:sub(#entry.text - n, #entry.text - n) ~= qfBufferLines[entry.lnum]:sub(#qfBufferLines[entry.lnum] - n, #qfBufferLines[entry.lnum] - n) then
--                 endOfChange = #entry.text - n
--                 endOfChangeInChangedVersion = #qfBufferLines[entry.lnum] - n
--                 break
--             end
--         end
--
--         endOfChange = math.max(endOfChange, startOfChange - changedVersionOffset - 1)
--         local minReplacement = StringRange(qfBufferLines[entry.lnum], startOfChange, endOfChangeInChangedVersion)
--
--         local longest = ""
--         local startOfCommonPart = -1
--         local endOfCommonPart = -1
--         for n = 1, #entry.text do
--             -- Find the largest common part between the qf entry and the line in the file
--             -- We need the old regex engine, because the new one doesn't always find the match in this case
--             local commonResult = vim.fn.matchlist(entry.text:sub(n) .. "\\n" .. qfBufferLines[entry.lnum], regexp_engine .. "\\C\\v^(.+).*\\n.*\\1")
--             if #commonResult == 0 then
--                 break
--             end
--             local common = commonResult[2]
--             local startIndex = n
--             local endIndex = startIndex + #common - 1
--             if #common > #longest and startIndex <= startOfChange and endIndex >= endOfChange then
--                 longest = common
--                 startOfCommonPart = startIndex
--                 endOfCommonPart = endIndex
--             end
--         end
--         local longestReplacement = StringRange(entry.text, startOfCommonPart, startOfChange - 1) .. minReplacement .. StringRange(entry.text, endOfChange + 1, endOfCommonPart)
--         table.insert(changes, { original = longest, replacement = longestReplacement })
--     end
--     return changes
-- end
--
-- function HasSubstringOnce(string, escapedSubstring)
--     return string:find("\\V" .. escapedSubstring .. "\\(\\.\\*" .. escapedSubstring .. "\\)\\@\\!") ~= nil
-- end
--
-- function StringRange(string, startIndex, endIndex)
--     return string:sub(startIndex, endIndex + 1)
-- end
--
-- function getQfOrLocationList(isLocationList, qfWinNumber)
--     if isLocationList then
--         return vim.fn.getloclist(qfWinNumber)
--     else
--         return vim.fn.getqflist()
--     end
-- end

return M
