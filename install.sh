#!/usr/bin/env bash
set -e

DOTFILES_DIR=$(pwd)

if [[ $(uname) == 'Darwin' ]]; then

  if [[ $(uname -m) == 'arm64' ]]; then
    echo "Setting Path to /opt/homebrew/bin:\$PATH"
      export PATH=/opt/homebrew/bin:$PATH
  else
    echo "Setting Path to /usr/local/bin:\$PATH"
      export PATH=/usr/local/bin:$PATH
  fi

  if [[ $(command -v brew) != 0 ]]; then
    echo 'Installing Homebrew and packages...'
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      brew update
      brew tap homebrew/bundle
      brew bundle
  else 
    echo 'Installing packages...'
      brew update
      brew tap homebrew/bundle
      brew bundle
  fi

  grep -Fxq '$(brew --prefix)/bin/zsh' /etc/shells || sudo bash -c "echo $(brew --prefix)/bin/zsh >> /etc/shells"
  chsh -s $(brew --prefix)/bin/zsh "$USER"

  sh ./macos.sh

  ln -sf "$DOTFILES_DIR/bin/tm" $(brew --prefix)/bin/
  ln -sf "$DOTFILES_DIR/bin/git-up" $(brew --prefix)/bin/

  ln -sf "$DOTFILES_DIR/.zshrc" ~
fi

if [[ $(uname) == 'OpenBSD' ]]; then
  ln -sf "$DOTFILES_DIR/.zshrc.bsd" ~/.zshrc
fi

ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.tmux.conf" ~
ln -sf "$DOTFILES_DIR/.vimrc" ~
ln -sf "$DOTFILES_DIR/.ansible.cfg" ~
ln -sf "$DOTFILES_DIR/.curlrc" ~
ln -sf "$DOTFILES_DIR/.alias" ~
ln -sf "$DOTFILES_DIR/.functions" ~
ln -sf "$DOTFILES_DIR/config" ~/.ssh/
ln -sf "$DOTFILES_DIR/.newsboat" ~

mkdir -p ~/.vim/colors
ln -sf $DOTFILES_DIR/nord.vim ~/.vim/colors
git clone https://github.com/hashivim/vim-terraform.git ~/.vim/pack/plugins/start/vim-terraform
git clone https://github.com/editorconfig/editorconfig-vim.git ~/.vim/pack/plugins/start/editorconfig-vim

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

exit 0;
