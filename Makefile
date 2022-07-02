PACKER_PATH=~/.local/share/nvim/site/pack/packer/start

packages-install:
	apt-get install software-properties-common -y
	add-apt-repository -y ppa:git-core/ppa
	add-apt-repository ppa:neovim-ppa/stable -y
	add-apt-repository ppa:neovim-ppa/unstable -y
	apt-get update -y
	apt-get install -y zsh     \
		  	   kitty   \
			   neovim  \
			   git	   \
			   xclip

oh-my-zsh-install:
	rm -rf ~/.oh-my-zsh || exit 0
	rm ~/.zshrc || exit 0
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm ~/.zshrc || exit 0
	ln -sf $(PWD)/zshrc/.zshrc ~/.zshrc

font-install:
	rm -rf nerd-fonts || exit 0
	rm -rf ~/.local/share/fonts/NerdFonts
	git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
	cd nerd-fonts && git sparse-checkout add patched-fonts/FiraCode
	./nerd-fonts/install.sh FiraCode

nvim-configure:
	rm -rf nvim/plugin || exit 0
	rm -rf ~/.local/share/nvim || exit 0
	rm -rf ~/.config/nvim || exit 0
	rm -rf $(PACKER_PATH) || exit 0
	mkdir -p $(PACKER_PATH)
	git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER_PATH)/packer.nvim
	ln -snf $(PWD)/nvim ~/.config/nvim

kitty-configure:
	rm -rf ~/.local/kitty.app || exit 0
	rm -f ~/.local/share/applications/kitty.desktop || exit 0
	rm -rf ~/.config/kitty || exit 0
	ln -snf $(PWD)/kitty ~/.config/kitty
	mkdir -p ~/.local/share/applications
	cp /usr/share/applications/kitty.desktop ~/.local/share/applications
	sed -i 's/^Exec=kitty *$$/Exec=kitty --single-instance/g' ~/.local/share/applications/kitty.desktop

# TODO: Make packer to install in headless mode without errors
