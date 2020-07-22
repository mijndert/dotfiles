#!/usr/bin/env bash

set -e

DOTFILES_DIR=$(pwd)

# Mac-specific stuff goes here
if [[ $(uname) == 'Darwin' ]]; then
  sudo xcodebuild -license accept
  
  if [[ $(command -v brew) != 0 ]]; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  sh ./macos.sh

  brew update
  brew tap homebrew/bundle
  brew bundle
fi

# Set up shell
curl -Lo /tmp/install-ohmyzsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sh /tmp/install-ohmyzsh.sh --unattended
grep -Fxq '/usr/local/bin/zsh' /etc/shells || sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
chsh -s /usr/local/bin/zsh "$USER"
npm install --global pure-prompt

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
ln -sf "$DOTFILES_DIR/bin" ~
ln -sf "$DOTFILES_DIR/.newsboat" ~

# Virtualenvwrapper 
source ~/.zshrc
pip install virtualenv virtualenvwrapper

# VS Code
code
ln -sf "$DOTFILES_DIR/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
for i in $(cat vscode/vscode_extensions.txt); do code --install-extension "$i"; done