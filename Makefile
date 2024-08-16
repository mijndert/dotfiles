SHELL := /bin/bash

.PHONY: all install_homebrew install_packages setup_shell clone_repos create_symlinks install_rosetta

all: install_homebrew install_packages setup_shell clone_repos create_symlinks install_rosetta

install_homebrew:
ifeq ($(shell uname), Darwin)
    @if ! command -v brew >/dev/null 2>&1; then \
        echo 'Installing Homebrew...'; \
        /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; \
        if [ -d "/opt/homebrew" ]; then \
            HOMEBREW_PREFIX="/opt/homebrew"; \
        else \
        	HOMEBREW_PREFIX="/usr/local"; \
        fi; \
        eval "$$($${HOMEBREW_PREFIX}/bin/brew shellenv)"; \
    fi
endif

install_packages:
ifeq ($(shell uname), Darwin)
    @echo 'Installing packages...'; \
    brew update; \
    brew tap homebrew/bundle; \
    brew bundle
endif

setup_shell:
ifeq ($(shell uname), Darwin)
    @grep -Fxq "$$(brew --prefix)/bin/zsh" /etc/shells || sudo bash -c "echo $$(brew --prefix)/bin/zsh >> /etc/shells"; \
    chsh -s $$(brew --prefix)/bin/zsh "$$USER"; \
    sh ./macos.sh
endif

clone_repos:
    @git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions; \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

create_symlinks:
    @ln -sf "$$(PWD)/.zshrc" ~; \
    ln -sf "$$(PWD)/.alias" ~; \
    ln -sf "$$(PWD)/.functions" ~; \
    ln -sf "$$(PWD)/.gitconfig" ~; \
    ln -sf "$$(PWD)/.gitconfig-personal" ~; \
    ln -sf "$$(PWD)/.gitconfig-work" ~; \
    ln -sf "$$(PWD)/.tmux.conf" ~; \
    ln -sf "$$(PWD)/.vimrc" ~; \
    ln -sf "$$(PWD)/.curlrc" ~; \
    ln -sf "$$(PWD)/.alacritty.toml" ~; \
    ln -sf "$$(PWD)/.ripgreprc" ~; \
    mkdir -p ~/.ssh && ln -sf "$$(PWD)/config" ~/.ssh/

install_rosetta:
ifeq ($(shell uname), Darwin)
    @echo "installing Rosetta"; \
    softwareupdate --install-rosetta --agree-to-license
endif