export ZSH=~/.oh-my-zsh
export EDITOR=vim
export PATH=/usr/local/bin:$PATH
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# oh-my-zsh
ZSH_THEME=""
plugins=(git osx cp aws docker docker-compose)
source $ZSH/oh-my-zsh.sh

# source external files
source ~/.aliases
source ~/.functions
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# set prompt
autoload -U promptinit; promptinit
prompt pure

