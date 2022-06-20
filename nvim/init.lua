-----------------------------------------------------------
-- Пакетный менеджер
-----------------------------------------------------------

-- Список плагинов
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Пакетный менеджер
    use 'EdenEast/nightfox.nvim' -- Тема
end)

-----------------------------------------------------------
-- Основные настройки 
-----------------------------------------------------------

-- Работа хоткеев для русской раскладки
vim.o.langmap = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
-- Номера строк
vim.o.number = true
-- Автодополнение
vim.o.completeopt = 'menu,menuone,noselect'
-- Игнорируем регистр если в искомой строке нет заглавных букв
vim.o.ignorecase = true
vim.o.smartcase = true
-- Выделение искомой строки
vim.o.hlsearch = true
-- Возможность отменять изменения после выключения компьютера/вима
vim.o.undofile = true
-- Автоматические отступы
vim.o.autoindent = true
-- Цветовая схема
vim.o.termguicolors = true
-- Подсвечиваем текущую строку
vim.o.cursorline = true
-- Уменьшение времени апдейта
vim.o.updatetime = 250
-- Колонка для знаков до номеров строк
vim.o.signcolumn = 'yes'
-- Учитывать смещение при поиске
vim.o.cpoptions = 'n'

-- Выделение для скопированного текста 
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-----------------------------------------------------------
-- Основные хоткеи 
-----------------------------------------------------------

-- Правильная работа с переносами слов 
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'л', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'о', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Пробел в качестве <leader>
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Перемещение между окнами 
vim.keymap.set('n', '<c-k>', '<c-w><up>')
vim.keymap.set('n', '<c-j>', '<c-w><down>')
vim.keymap.set('n', '<c-l>', '<c-w><right>')
vim.keymap.set('n', '<c-h>', '<C-w><Left>')
-- Выключаем выделение после поиска
vim.keymap.set('n', '//', ':nohlsearch<CR>')
-- Копирование/вставка для системного буфера
vim.keymap.set({ 'n', 'v' }, '"y', '"+y')
vim.keymap.set('n', '"Y', '"+Y')
vim.keymap.set('n', '"p', '"+p')
vim.keymap.set('n', '"P', '"+P')
-- Редактировние и применение исходного конфига
vim.keymap.set('n', '<leader>vl', ':vsp $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>vs', ':source $MYVIMRC<CR>')

-----------------------------------------------------------
-- Плагины
-----------------------------------------------------------

-- packer - пакетный менеджер
-- Использовать команду `:PackerSync` при добавлении, удалениии, изменении конфигурации и тд.

-- nightfox - тема
vim.cmd('colorscheme nightfox')
