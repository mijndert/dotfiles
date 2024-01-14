#!/usr/bin/env bash
set -e

DOTFILES_DIR=$(pwd)

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

  echo "installing Rosetta"
  softwareupdate --install-rosetta

  grep -Fxq '$(brew --prefix)/bin/zsh' /etc/shells || sudo bash -c "echo $(brew --prefix)/bin/zsh >> /etc/shells"
  chsh -s $(brew --prefix)/bin/zsh "$USER"

  ln -sf "$DOTFILES_DIR/bin/git-up" $(brew --prefix)/bin/
  ln -sf "$DOTFILES_DIR/bin/chktf" $(brew --prefix)/bin/

  sh ./macos.sh
fi

ln -sf "$DOTFILES_DIR/.zshrc" ~
ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.gitconfig-personal" ~
ln -sf "$DOTFILES_DIR/.gitconfig-work" ~
ln -sf "$DOTFILES_DIR/.tmux.conf" ~
ln -sf "$DOTFILES_DIR/.vimrc" ~
ln -sf "$DOTFILES_DIR/.ansible.cfg" ~
ln -sf "$DOTFILES_DIR/.curlrc" ~
ln -sf "$DOTFILES_DIR/.alias" ~
ln -sf "$DOTFILES_DIR/.functions" ~
ln -sf "$DOTFILES_DIR/config" ~/.ssh/
ln -sf "$DOTFILES_DIR/.alacritty.toml" ~

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# git clone https://github.com/hashivim/vim-terraform.git ~/.vim/pack/plugins/start/vim-terraform
# git clone https://github.com/editorconfig/editorconfig-vim.git ~/.vim/pack/plugins/start/editorconfig-vim
# git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula

# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

exit 0;
