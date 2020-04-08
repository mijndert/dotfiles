export ZSH=~/.oh-my-zsh
export EDITOR=vim
export PATH=PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# oh-my-zsh
ZSH_THEME=""
plugins=(git osx cp aws docker docker-compose virtualenv)

# source external files
source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.functions
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# set prompt
autoload -U promptinit; promptinit
prompt pure

# override whatever is setting this to 1
export VIRTUAL_ENV_DISABLE_PROMPT=
