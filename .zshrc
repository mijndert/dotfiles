export ZSH=~/.oh-my-zsh
export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=$(brew --prefix)/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH

ZSH_THEME=""
plugins=(git cp aws brew docker kubectl)
DISABLE_MAGIC_FUNCTIONS=true 

DISABLE_UPDATE_PROMPT=true
export UPDATE_ZSH_DAYS=7

source $ZSH/oh-my-zsh.sh
source ~/.alias
source ~/.functions
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz promptinit; promptinit
prompt pure
