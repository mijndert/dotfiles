#!/usr/bin/env bash

# Do all macOS-specific things
if [[ $(uname) == 'Darwin' ]]; then
  if [[ $(command -v brew) != 0 ]]; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  # Set macOS defaults
  sh ./macos.sh

  # Install all dependencies from Brewfile
  brew update
  brew tap homebrew/bundle
  brew bundle
fi

# Do python stuff
ln -s -f /usr/local/bin/pip3 /usr/local/bin/pip
ln -s -f /usr/local/bin/python3 /usr/local/bin/python
pip install virtualenv virtualenvwrapper

# Install shell
curl -Lo /tmp/install-ohmyzsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sh /tmp/install-ohmyzsh.sh --unattended
grep -Fxq '/usr/local/bin/zsh' /etc/shells || sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
chsh -s /usr/local/bin/zsh "$USER"

# Get the dotfiles installation directory
DOTFILES_DIR=$(pwd)

# Link dotfiles
ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.zshrc" ~
ln -sf "$DOTFILES_DIR/.tmux.conf" ~
ln -sf "$DOTFILES_DIR/.vimrc" ~
ln -sf "$DOTFILES_DIR/.ansible.cfg" ~
ln -sf "$DOTFILES_DIR/.curlrc" ~
ln -sf "$DOTFILES_DIR/.alias" ~
ln -sf "$DOTFILES_DIR/.functions" ~
ln -sf "$DOTFILES_DIR/config" ~/.ssh/

# Install pure-prompt
npm install --global pure-prompt
