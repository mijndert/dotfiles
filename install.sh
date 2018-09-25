#!/usr/bin/env bash

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install all dependencies from Brewfile
brew update
brew tap homebrew/bundle
brew bundle

# Install Bash
brew install bash bash-completion
grep -Fxq '/usr/local/bin/bash' /etc/shells || sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
chsh -s /usr/local/bin/bash $USER

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

# Set macOS defaults
source macos.sh
