return {
    {
        "RamilGN/gpt",
        dev = true,
        cmd = { "Gpt" },
        opts = {},
    },
    {
        "RamilGN/git",
        dev = true,
        cmd = { "GitShowPrev", "GitLog", "GitLogG" },
        opts = {
            delta = true,
        },
    },
    {
        "RamilGN/note",
        dev = true,
        opts = {
            journal_dir = vim.g.home_dir .. "/private/notes",
        },
    },
}
