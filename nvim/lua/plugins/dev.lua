return {
    {
        "RamilGN/git",
        dev = true,
        cmd = { "GitShow", "GitShowPrev", "GitLog", "GitLogG" },
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
