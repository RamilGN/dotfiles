ubuntu-prepare:
	apt-get update
	apt-get install git # система контроля версий
	apt-get install xclip # работа с буфером обмена из командной строки

nvim-install:
	rm -rf nvim/plugin || exit 0
	rm -rf ~/.local/share/nvim || exit 0
	rm -rf ~/.config/nvim || exit 0
	ln -snf $(PWD)/nvim ~/.config/nvim
