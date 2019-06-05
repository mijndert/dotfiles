#!/usr/bin/env bash

# Do all macOS-specific things
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Set macOS defaults
  source macos.sh

  # Install all dependencies from Brewfile
  brew update
  brew tap homebrew/bundle
  brew bundle

  # Install Bash
  #brew install bash bash-completion
  #grep -Fxq '/usr/local/bin/bash' /etc/shells || sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
  #chsh -s /usr/local/bin/bash $USER
  curl -Lo /tmp/install-ohmyzsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  sh /tmp/install-ohmyzsh.sh --unattended
  chsh -s /usr/local/bin/zsh $USER
fi

# Get the dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Link dotfiles
ln -sf "$DOTFILES_DIR/.aliases" ~
ln -sf "$DOTFILES_DIR/.aws_completer" ~
ln -sf "$DOTFILES_DIR/.bash_profile" ~
ln -sf "$DOTFILES_DIR/.bash_prompt" ~
ln -sf "$DOTFILES_DIR/.exports" ~
ln -sf "$DOTFILES_DIR/.functions" ~
ln -sf "$DOTFILES_DIR/.gitconfig" ~

# Link ssh client configuration
ln -sf "$DOTFILES_DIR/config" ~/.ssh/
