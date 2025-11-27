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

  echo "installing Rosetta"
  softwareupdate --install-rosetta --agree-to-license

  sh ./macos.sh
fi

# Install zsh plugins
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

if [ ! -d ~/.zsh/fzf-tab ]; then
    git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
fi

# Vim plug 
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Symlink all dotfiles 
ln -sf "$PWD/.zshrc" ~
ln -sf "$PWD/.alias" ~
ln -sf "$PWD/.functions" ~
ln -sf "$PWD/.gitconfig" ~
ln -sf "$PWD/.gitconfig-personal" ~
ln -sf "$PWD/.gitconfig-work" ~
ln -sf "$PWD/.tmux.conf" ~
ln -sf "$PWD/.vimrc" ~
ln -sf "$PWD/.curlrc" ~
ln -sf "$PWD/.ripgreprc" ~

mkdir -p ~/.config/k9s && ln -sf "$PWD/k9s_config.yml" ~/Library/Application\ Support/k9s/config.yaml
mkdir -p ~/.config/ghostty && ln -sf "$PWD/ghostty_config" ~/.config/ghostty/config
mkdir -p ~/.ssh && ln -sf "$PWD/config" ~/.ssh/
mkdir -p ~/Library/Application\ Support/Code/User && ln -sf "$PWD/vscode_settings.json" ~/Library/Application\ Support/Code/User/settings.json

# Install k9s theme
OUT="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
mkdir -p "$OUT"
curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$OUT" --strip-components=2 k9s-main/dist

# Bat config
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build