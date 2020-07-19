export ZSH=~/.oh-my-zsh
export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=/usr/local/opt/python/libexec/bin:~/bin:$PATH

export VIRTUAL_ENV_DISABLE_PROMPT=
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3

ZSH_THEME=""
plugins=(git osx cp aws brew pip python docker)
DISABLE_MAGIC_FUNCTIONS=true 

DISABLE_UPDATE_PROMPT=true
export UPDATE_ZSH_DAYS=7

source $ZSH/oh-my-zsh.sh
source ~/.alias
source ~/.functions
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/bin/virtualenvwrapper.sh

autoload -U promptinit; promptinit
prompt pure
