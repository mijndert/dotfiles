#!/usr/bin/env bash

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if [[ $(uname) == 'Darwin' ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo 'Installing Homebrew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    [ -d "/opt/homebrew" ] && HOMEBREW_PREFIX="/opt/homebrew" || HOMEBREW_PREFIX="/usr/local"
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  fi

  echo 'Installing packages...'
  brew update
  brew bundle

  ZSH_PATH="$(brew --prefix)/bin/zsh"
  if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  [[ "$SHELL" == "$ZSH_PATH" ]] || chsh -s "$ZSH_PATH" "$USER"

  if ! /usr/bin/pgrep -q oahd; then
    echo "Installing Rosetta..."
    softwareupdate --install-rosetta --agree-to-license
  fi

  # Start container
  brew services start container
fi

# Install zsh plugins
[ -d ~/.zsh/zsh-autosuggestions ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Vim plug
[ -f ~/.vim/autoload/plug.vim ] || \
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Symlink all dotfiles
for f in .zshrc .alias .functions .gitconfig .gitconfig-personal .gitconfig-work .tmux.conf .vimrc .curlrc .ripgreprc; do
  ln -sfn "$DOTFILES/$f" "$HOME/$f"
done

mkdir -p ~/.config/k9s && ln -sfn "$DOTFILES/k9s_config.yml" ~/.config/k9s/config.yaml
mkdir -p ~/.config/ghostty && ln -sfn "$DOTFILES/ghostty_config" ~/.config/ghostty/config
mkdir -p ~/.ssh && ln -sfn "$DOTFILES/config" ~/.ssh/config
mkdir -p ~/Library/Application\ Support/Code/User && \
  ln -sfn "$DOTFILES/vscode_settings.json" ~/Library/Application\ Support/Code/User/settings.json

# Install k9s theme
K9S_SKINS="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
if [ ! -d "$K9S_SKINS" ] || [ -z "$(ls -A "$K9S_SKINS" 2>/dev/null)" ]; then
  mkdir -p "$K9S_SKINS"
  curl -fsSL https://github.com/catppuccin/k9s/archive/main.tar.gz \
    | tar xz -C "$K9S_SKINS" --strip-components=2 k9s-main/dist
fi

# Bat config
BAT_THEME_DIR="$(bat --config-dir)/themes"
BAT_THEME_FILE="$BAT_THEME_DIR/Catppuccin Mocha.tmTheme"
if [ ! -f "$BAT_THEME_FILE" ]; then
  mkdir -p "$BAT_THEME_DIR"
  curl -fsSLo "$BAT_THEME_FILE" \
    https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build
fi

# zsh-patina
mkdir -p ~/.config/zsh-patina && \
  ln -sfn "$DOTFILES/zsh-patina" ~/.config/zsh-patina/config.toml

# TPM
[ -d ~/.tmux/plugins/tpm ] || \
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install vim plugins (requires the symlinked .vimrc above)
vim +PlugInstall +qall

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins
