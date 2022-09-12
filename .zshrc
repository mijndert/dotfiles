export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=$(brew --prefix)/opt/python@3.10/libexec/bin:$(brew --prefix)/bin:/usr/local/bin:/usr/local/sbin:$PATH
export GPG_TTY=$(tty)
export DOCKER_BUILDKIT=1

bindkey "^R" history-incremental-search-backward

SAVEHIST=5000
HISTFILE=~/.zsh_history

setopt auto_cd
cdpath=($HOME/dev)

autoload -U colors
colors

autoload -Uz compinit
compinit

autoload -U promptinit
promptinit
zstyle :prompt:pure:git:stash show yes
prompt pure

source ~/.alias
source ~/.functions
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
