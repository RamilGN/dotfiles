return {
    {
        "RamilGN/gpt",
        dev = true,
        opts = {},
    },
    {
        "RamilGN/git",
        dev = true,
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
