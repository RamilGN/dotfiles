local diagnostic = vim.diagnostic
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- Standard
opt.mouse = nil -- Mouse off
opt.completeopt = "menu,menuone,noselect" -- Autocomplete
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Ignore case when searching if there is no capital letter
opt.keymap = "russian-jcukenwin" -- RU keyboard layout
opt.iminsert = 0 -- EN layout default in insert
opt.imsearch = -1 -- EN layout default in search
opt.spelllang = { "en_us", "ru" } -- Spell dictionaries
opt.number = true -- Line numbers
opt.relativenumber = true -- Relative numbers
opt.scrolloff = 10 -- Show some lines after cursor
opt.showcmd = false -- Don't show commands/keypresses
opt.splitbelow = true -- Horizontal split below
opt.splitright = true -- Vertical split right
opt.termguicolors = true -- Term colors
opt.undofile = true -- Undo after rebooting
opt.cursorline = true -- Highlight current line
opt.updatetime = 1000 -- Faster auto-completion and etc...
opt.timeoutlen = 350 -- Faster shortcuts
opt.signcolumn = "yes:2" -- Sign column
opt.swapfile = false -- Swap file off
opt.list = true -- Show trailing whitespaces, tabs etc...
opt.autoindent = true -- Copy indent from current line to next
opt.smartindent = true -- Smart indent
opt.wrap = true -- Wrap lines
opt.expandtab = true -- Tabs to spaces
opt.tabstop = 4 -- Number of spaces that tab counts for
opt.shiftwidth = 4 -- Tabs width
opt.softtabstop = 4 -- Tabs width while performing editing
opt.laststatus = 3 -- Global statusline
opt.autowriteall = true -- Autowrite
opt.clipboard = "unnamed,unnamedplus" -- System clipboard
opt.pumheight = 12 -- Set maximum number of items in the pop-up menu
opt.pumblend = 17 -- Transparency for pop-up window
opt.scrollback = 100000 -- Scrollback lines for terminal buffer
opt.formatoptions = opt.formatoptions - "c" - "r" - "o" -- Don't continue comments
-- opt.foldenable = false
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Diagnositc
diagnostic.config({
    virtual_text = false, -- Don't show diagnostics near line
    update_in_insert = true -- Update diagnostics in insert mode
})
-- Diagnositc signs
fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- Globals
g.max_byte_size = 1024 * 206 -- Using for plugin and other constraints
g.home_dir = vim.fn.getenv("HOME") -- Home directory
g.mapleader = " " -- Reset leader keymap
g.maplocalleader = " " -- Reset leader keymap for buffer

-- Disable some builtin vim plugins
g.loaded_2html_plugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_logipat = 1
g.loaded_matchit = 1
g.loaded_rrhelper = 1
g.loaded_tutor = 1
g.loaded_rplugin = 1
g.loaded_syntax = 1
g.loaded_synmenu = 1
g.loaded_optwin = 1
g.loaded_compiler = 1
g.loaded_bugreport = 1
g.loaded_ftplugin = 1
-- g.loaded_spellfile_plugin = 1
-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
-- g.loaded_netrwSettings = 1
-- g.loaded_netrwFileHandlers = 1
-- g.loaded_vimball = 1
-- g.loaded_vimballPlugin = 1
-- g.loaded_zip = 1
-- g.loaded_zipPlugin = 1
-- g.loaded_gzip = 1
-- g.loaded_tar = 1
-- g.loaded_tarPlugin = 1

-- Disable some builtin vim providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
