.PHONY: all
all: dnf-packages git kitty zsh fonts nvim asdf

.PHONY: dnf-packages
dnf-packages:
	dnf install -y \
					bat \
					curl \
					fd-find \ # neovim
					fira-code-fonts \
					sqlite3 \ # rpm
					fzf \ # neovim
					gcc-c++ \ # treesitter
					git \
					git-delta \
					htop \
					ripgrep \ # neovim
					transmission \
					util-linux-user \ # chsh
					xclip \ # neovim
					zsh

.PHONY: flatpak
flatpak:
	flatpak install flathub org.videolan.VLC
	flatpak install flathub org.telegram.desktop
	flatpak install flathub com.discordapp.Discord

.PHONY: kitty
kitty:
	rm -rf ~/.local/kitty.app
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

.PHONY: docker
docker:
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker

.PHONY: zsh
zsh: oh-my-zsh zsh-plugins

.PHONY: oh-my-zsh
oh-my-zsh:
	rm -rf ~/.oh-my-zsh
	rm -f ~/.zshrc
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm -f ~/.zshrc
	ln -sf $(PWD)/zshrc/.zshrc ~/.zshrc
	chsh -s $$(which zsh)

OH_MY_ZSH_CUSTOM_PLUGINS_PATH:=~/.oh-my-zsh/custom/plugins
.PHONY: zsh-plugins
zsh-plugins:
	rm -rf $(OH_MY_ZSH_CUSTOM_PLUGINS_PATH)/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(OH_MY_ZSH_CUSTOM_PLUGINS_PATH)/zsh-syntax-highlighting
	rm -rf $(OH_MY_ZSH_CUSTOM_PLUGINS_PATH)/zsh-vi-mode
	git clone https://github.com/jeffreytse/zsh-vi-mode $(OH_MY_ZSH_CUSTOM_PLUGINS_PATH)/zsh-vi-mode

.PHONY: font
fonts:
	rm -rf $(PWD)/nerd-fonts
	rm -rf ~/.local/share/fonts/NerdFonts
	git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
	cd nerd-fonts && git sparse-checkout add patched-fonts/FiraCode
	./nerd-fonts/install.sh FiraCode

.PHONY: codecs
codecs:
	dnf install -y \
		gstreamer1-plugins-{bad-\*,good-\*,base} \
		gstreamer1-plugin-openh264 \
		gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel \
		lame\* --exclude=lame-devel
	dnf group upgrade --with-optional Multimedia

.PHONY: nvim
nvim:
	rm -rf $(PWD)/nvim/plugin
	rm -rf ~/.local/share/nvim
	rm -rf ~/.config/nvim
	ln -snf $(PWD)/nvim ~/.config/nvim

.PHONY: git
git:
	ln -sf $(PWD)/git/.gitconfig ~/.gitconfig
	git config --global core.excludesfile $(PWD)/git/.gitignore

ASDF_PATH:=~/.asdf
ASDFRC_PATH:=~/.asdfrc
.PHONY: asdf
asdf:
	rm -rf $(ASDF_PATH)
	rm -f $(ASDFRC_PATH)
	git clone git@github.com:asdf-vm/asdf.git $(ASDF_PATH)
	ln -sf $(PWD)/asdfrc/.asdfrc $(ASDFRC_PATH)

.PHONY: nodejs
asdf-nodejs:
	asdf plugin-add nodejs
	asdf install nodejs latest
	asdf global nodejs latest

.PHONY: ruby
asdf-ruby:
	dnf instal -y libyaml-devel
	asdf plugin add ruby
	asdf install ruby latest
	asdf global ruby latest

.PHONY: golang
asdf-golang:
	asdf plugin add golang
	asdf install golang latest
	asdf global golang latest

.PHONY: python
asdf-python:
	asdf plugin add python
	asdf install python latest
	asdf global python latest

.PHONY: python
asdf-lua:
	asdf plugin add lua
	asdf install lua latest
	asdf global lua latest
