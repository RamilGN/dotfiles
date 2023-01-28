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
vim.opt.showcmd = false -- Don't show commands/keypresses
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
vim.g.max_byte_size = 1024 * 206 -- Using for plugin and other constraints
vim.g.home_dir = vim.fn.getenv("HOME") -- Home directory
vim.g.mapleader = " " -- Reset leader keymap

-- Disable some builtin vim plugins
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tutor = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_syntax = 1
vim.g.loaded_synmenu = 1
vim.g.loaded_optwin = 1
vim.g.loaded_compiler = 1
vim.g.loaded_bugreport = 1
vim.g.loaded_ftplugin = 1
-- vim.g.loaded_spellfile_plugin = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_netrwFileHandlers = 1
-- vim.g.loaded_vimball = 1
-- vim.g.loaded_vimballPlugin = 1
-- vim.g.loaded_zip = 1
-- vim.g.loaded_zipPlugin = 1
-- vim.g.loaded_gzip = 1
-- vim.g.loaded_tar = 1
-- vim.g.loaded_tarPlugin = 1

-- Disable some builtin vim providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
