#!/usr/bin/env bash
set -e

DOTFILES_DIR=$(pwd)

if [[ $(uname) == 'Darwin' ]]; then

  if [[ $(command -v brew) != 0 ]]; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  else 
    brew update
    brew tap homebrew/bundle
    brew bundle
  fi

  grep -Fxq '$(brew --prefix)/bin/zsh' /etc/shells || sudo bash -c "echo $(brew --prefix)/bin/zsh >> /etc/shells"
  chsh -s $(brew --prefix)/bin/zsh "$USER"

  ln -sf "$DOTFILES_DIR/bin/tm" $(brew --prefix)/bin/
  ln -sf "$DOTFILES_DIR/bin/git-up" $(brew --prefix)/bin/

  sh ./macos.sh
fi

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