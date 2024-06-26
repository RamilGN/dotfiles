return {
    setup = function()
        -- Standard
        vim.opt.autoindent = true -- Copy indent from current line to next
        vim.opt.autowriteall = true -- Autowrite all
        vim.opt.clipboard = "unnamedplus" -- System clipboard
        vim.opt.completeopt = "menu,menuone,noselect" -- Autocomplete
        vim.opt.cursorline = true -- Highlight current line
        vim.opt.expandtab = true -- Tabs to spaces
        vim.opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }
        vim.opt.formatoptions = "jcroqlnt" -- tcqj
        vim.opt.grepprg = "rg --vimgrep" -- Command for grep
        vim.opt.ignorecase = true -- Ignore case when searching
        vim.opt.laststatus = 3 -- Global statusline
        vim.opt.list = true -- Show trailing whitespaces, tabs etc...
        vim.opt.modeline = false
        vim.opt.mouse = ""
        vim.opt.pumblend = 17
        vim.opt.pumheight = 12 -- Set maximum number of items in the pop-up menu
        vim.opt.number = true -- Line numbers
        vim.opt.relativenumber = true -- Relative numbers
        vim.opt.scrollback = 100000 -- Scrollback lines for terminal buffer
        vim.opt.scrolloff = 10 -- Show some lines after cursor
        vim.opt.shiftround = true -- Round to shiftwidth
        vim.opt.shiftwidth = 2 -- Tabs width
        vim.opt.showmode = false -- Statusline line dup
        vim.opt.signcolumn = "yes:2" -- Sign column
        vim.opt.smartcase = true -- Ignore case when searching if there is no capital letter
        vim.opt.smartindent = true -- Smart indent
        vim.opt.spelllang = { "en", "ru" } -- Spell dictionaries
        vim.opt.splitbelow = true -- Horizontal split below
        vim.opt.splitright = true -- Vertical split right
        vim.opt.swapfile = false -- Swap file off
        vim.opt.tabstop = 4 -- Number of spaces that tab counts for
        vim.opt.termguicolors = true -- Term colors
        vim.opt.timeoutlen = 300
        vim.opt.undofile = true -- Undo after rebooting
        vim.opt.undolevels = 10000 -- More undo
        vim.opt.updatetime = 200 -- Faster auto-completion and etc...
        vim.opt.virtualedit = "block" -- Allow going past the end of line in visual block mode
        vim.opt.wrap = true -- Wrap lines

        -- Globals
        vim.g.max_byte_size = 1024 * 512 -- Using for plugin and other constraints
        vim.g.home_dir = vim.fn.getenv("HOME") -- Home directory

        -- Reset leader keymap
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "
    end,
}
