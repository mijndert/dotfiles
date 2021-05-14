#!/usr/bin/env bash

set -e

if [ ! -f ~/.zshenv ]; then
  echo "~/.zshenv not found, create it first to set HOMEBREW_DIR to either /opt/homebrew (ARM) or /usr/local (x86)"
  exit 0
fi

DOTFILES_DIR=$(pwd)

# Mac-specific stuff goes here
if [[ $(uname) == 'Darwin' ]]; then

  if [[ $(command -v brew) != 0 ]]; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  sh ./macos.sh

  brew update
  brew tap homebrew/bundle
  brew bundle

  # Set up shell
  curl -Lo /tmp/install-ohmyzsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  sh /tmp/install-ohmyzsh.sh --unattended
  grep -Fxq '$HOMEBREW_DIR/bin/zsh' /etc/shells || sudo bash -c "echo $HOMEBREW_DIR/bin/zsh >> /etc/shells"
  chsh -s $HOMEBREW_DIR/bin/zsh "$USER"
  npm install --global pure-prompt
fi

# Symlink all config files
ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.zshrc" ~
ln -sf "$DOTFILES_DIR/.tmux.conf" ~
ln -sf "$DOTFILES_DIR/.vimrc" ~
ln -sf "$DOTFILES_DIR/.ansible.cfg" ~
ln -sf "$DOTFILES_DIR/.curlrc" ~
ln -sf "$DOTFILES_DIR/.alias" ~
ln -sf "$DOTFILES_DIR/.functions" ~
ln -sf "$DOTFILES_DIR/config" ~/.ssh/
ln -sf "$DOTFILES_DIR/.newsboat" ~