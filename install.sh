#!/usr/bin/env bash
set -e

if [[ $(uname) == 'Darwin' ]]; then
  if [[ $(command -v brew) != 0 ]]; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    [ -d "/opt/homebrew" ] && HOMEBREW_PREFIX="/opt/homebrew" || HOMEBREW_PREFIX="/usr/local"
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  fi

  echo 'Installing packages...'
  brew update
  brew tap homebrew/bundle
  brew bundle

  grep -Fxq '$(brew --prefix)/bin/zsh' /etc/shells || sudo bash -c "echo $(brew --prefix)/bin/zsh >> /etc/shells"
  chsh -s $(brew --prefix)/bin/zsh "$USER"

  sh ./macos.sh

  echo "installing Rosetta"
  softwareupdate --install-rosetta --agree-to-license
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab

ln -sf "$(PWD)/.zshrc" ~
ln -sf "$(PWD)/.alias" ~
ln -sf "$(PWD)/.functions" ~
ln -sf "$(PWD)/.gitconfig" ~
ln -sf "$(PWD)/.gitconfig-personal" ~
ln -sf "$(PWD)/.gitconfig-work" ~
ln -sf "$(PWD)/.tmux.conf" ~
ln -sf "$(PWD)/.vimrc" ~
ln -sf "$(PWD)/.curlrc" ~
ln -sf "$(PWD)/.alacritty.toml" ~
ln -sf "$(PWD)/.ripgreprc" ~
mkdir ~/.config/ghostty && ln -sf "$(PWD)/ghostty_config" ~/.config/ghostty/config
mkdir ~/.ssh && ln -sf "$(PWD)/config" ~/.ssh/
