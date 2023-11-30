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
            workspaces = {
                default = {
                    path = vim.g.home_dir .. "/private/notes/personal",
                },
                [vim.g.home_dir .. "/insales"] = {
                    path = vim.g.home_dir .. "/private/notes/work",
                },
            },
        },
    },
}
