# export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH
export GPG_TTY=$(tty)

# Enable ctrl + R for backward search
bindkey "^R" history-incremental-search-backward

# Initialise colours
autoload -U colors
colors

# Set history file for autocompletion
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Quicker navigation to sub dirs in most visited dirs
setopt auto_cd
cdpath=($HOME/dev)

# Use modern completion system
autoload -Uz compinit
compinit

# Put the name of the Git branch in PS1
function parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1) /";
}
setopt PROMPT_SUBST
PS1="%~ \$(parse_git_branch)\$ "

source ~/.alias
source ~/.functions
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh