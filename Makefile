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
	rm -f ~/.local/kitty.app
	rm -f ~/.local/share/applications/kitty.desktop
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin installer=nightly launch=n
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin
	rm -rf ~/.config/kitty
	ln -sf $(PWD)/kitty ~/.config/kitty
	mkdir -p ~/.local/share/applications
	cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications
	cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications
	sed -i "s|Icon=kitty|Icon=$(PWD)/kitty/whiskers_256x256.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=/home/$(USER)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

.PHONY: oh-my-zsh
oh-my-zsh:
	rm -rf ~/.oh-my-zsh
	rm -f ~/.zshrc
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm -f ~/.zshrc
	ln -sf $(PWD)/zshrc/.zshrc ~/.zshrc
	chsh -s $$(which zsh)

.PHONY: font
font:
	rm -rf $(PWD)/nerd-fonts
	rm -rf ~/.local/share/fonts/NerdFonts
	git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
	cd nerd-fonts && git sparse-checkout add patched-fonts/FiraCode
	./nerd-fonts/install.sh FiraCode

.PHONY: nvim
PACKER_PATH=~/.local/share/nvim/site/pack/packer/start
nvim:
	rm -rf $(PWD)/nvim/plugin
	rm -rf ~/.local/share/nvim
	rm -rf ~/.config/nvim
	rm -rf $(PACKER_PATH)
	mkdir -p $(PACKER_PATH)
	git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER_PATH)/packer.nvim
	ln -snf $(PWD)/nvim ~/.config/nvim
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

.PHONY: asdf
ASDF_PATH=~/.asdf
ASDFRC_PATH=~/.asdfrc
asdf:
	rm -rf $(ASDF_PATH)
	rm -f $(ASDFRC_PATH)
	git clone git@github.com:asdf-vm/asdf.git $(ASDF_PATH)
	ln -sf $(PWD)/.asdfrc $(ASDFRC_PATH)

# TODO
# CI
# Make packer to install in headless mode without errors
