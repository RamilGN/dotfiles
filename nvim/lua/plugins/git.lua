local M = {}

function M.setup(use)
    -- Git decorations and buffer integration
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    untracked = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" }
                }
            })
        end
    })

    -- Git links
    use({
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("gitlinker").setup({
                opts = {
                    print_url = false,
                },
                callbacks = {
                    ["gitlab.insales.ru"] = require("gitlinker.hosts").get_gitlab_type_url
                },
            })
        end
    })
end

return M