PACKER_PATH=~/.local/share/nvim/site/pack/packer/start

.PHONY: packages
packages:
	apt-get install software-properties-common -y
	add-apt-repository -y ppa:git-core/ppa
	add-apt-repository ppa:neovim-ppa/stable -y
	add-apt-repository ppa:neovim-ppa/unstable -y
	apt-get update -y
	apt-get install -y zsh     \
			   neovim  \
			   git	   \
			   xclip   \
			   curl    \
			   bat	   \
			   fd-find \
			   fzf 	   \
			   ripgrep

.PHONY: packages-after
packages-after:
	ln -sf $$(which fdfind) ~/.local/bin/fd

.PHONY: kitty
kitty:
	rm -rf ~/.local/kitty.app || exit 0
	rm -f ~/.local/share/applications/kitty.desktop || exit 0
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin installer=nightly launch=n
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
	rm -rf ~/.config/kitty || exit 0
	ln -sf $(PWD)/kitty ~/.config/kitty
	mkdir -p ~/.local/share/applications
	cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
	cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
	sed -i "s|Icon=kitty|Icon=$(PWD)/kitty/whiskers_256x256.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=/home/$(USER)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

.PHONY: oh-my-zsh
oh-my-zsh:
	rm -rf ~/.oh-my-zsh || exit 0
	rm ~/.zshrc || exit 0
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm ~/.zshrc || exit 0
	ln -sf $(PWD)/zshrc/.zshrc ~/.zshrc
	chsh -s $$(which zsh)

.PHONY: font
font:
	rm -rf nerd-fonts || exit 0
	rm -rf ~/.local/share/fonts/NerdFonts
	git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
	cd nerd-fonts && git sparse-checkout add patched-fonts/FiraCode
	./nerd-fonts/install.sh FiraCode

.PHONY: nvim
nvim:
	rm -rf nvim/plugin || exit 0
	rm -rf ~/.local/share/nvim || exit 0
	rm -rf ~/.config/nvim || exit 0
	rm -rf $(PACKER_PATH) || exit 0
	mkdir -p $(PACKER_PATH)
	git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER_PATH)/packer.nvim
	ln -snf $(PWD)/nvim ~/.config/nvim

# TODO: Make packer to install in headless mode without errors
