export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH
export GPG_TTY=$(tty)
export DOCKER_BUILDKIT=1

# Enable ctrl + R for backward search
bindkey "^R" history-incremental-search-backward

# Init colors
autoload -U colors
colors

# Set history file for autocompletion
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY

# Quicker navigation to sub dirs in most visited dirs
setopt auto_cd
cdpath=($HOME/dev)

# Use modern completion system
autoload -Uz compinit
compinit

# Set ps1 and include git branch
function parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1 /";
}
setopt PROMPT_SUBST
#PS1='%F{15}%m%f:%F{27}%~%f %F{15}$(parse_git_branch)%f$ '
PS1='%m %F{33}%~%f $(parse_git_branch)$ '

# Import files
source ~/.alias
source ~/.functions
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
