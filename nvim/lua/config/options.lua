-- Standard
vim.opt.mouse = nil -- Mouse off
vim.opt.completeopt = "menu,menuone,noselect" -- Autocomplete
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Ignore case when searching if there is no capital letter
vim.opt.keymap = "russian-jcukenwin" -- RU keyboard layout
vim.opt.iminsert = 0 -- EN layout default in insert
vim.opt.imsearch = -1 -- EN layout default in search
vim.opt.spelllang = { "en", "ru" } -- Spell dictionaries
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative numbers
vim.opt.scrolloff = 10 -- Show some lines after cursor
vim.opt.splitbelow = true -- Horizontal split below
vim.opt.splitright = true -- Vertical split right
vim.opt.termguicolors = true -- Term colors
vim.opt.undofile = true -- Undo after rebooting
vim.opt.cursorline = true -- Highlight current line
vim.opt.updatetime = 500 -- Faster auto-completion and etc...
vim.opt.timeoutlen = 350 -- Faster shortcuts
vim.opt.signcolumn = "yes:2" -- Sign column
vim.opt.swapfile = false -- Swap file off
vim.opt.list = true -- Show trailing whitespaces, tabs etc...
vim.opt.autoindent = true -- Copy indent from current line to next
vim.opt.smartindent = true -- Smart indent
vim.opt.wrap = true -- Wrap lines
vim.opt.laststatus = 3 -- Global statusline
vim.opt.autowriteall = true -- Autowrite
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.undolevels = 10000
vim.opt.pumheight = 12 -- Set maximum number of items in the pop-up menu
vim.opt.pumblend = 17 -- Transparency for pop-up window
vim.opt.scrollback = 100000 -- Scrollback lines for terminal buffer
vim.opt.expandtab = true -- Tabs to spaces
vim.opt.tabstop = 4 -- Number of spaces that tab counts for
vim.opt.shiftwidth = 4 -- Tabs width
vim.opt.shiftround = true -- Round to shiftwidth

-- Globals
vim.g.max_byte_size = 1024 * 512 -- Using for plugin and other constraints
vim.g.home_dir = vim.fn.getenv("HOME") -- Home directory

-- Reset leader keymap
vim.g.mapleader = " "
vim.g.maplocalleader = " "
