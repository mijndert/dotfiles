export EDITOR=vim
#export LC_ALL=en_US.UTF-8  
#export LANG=en_US.UTF-8
export LC_ALL=C
export LANG=C
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
setopt APPEND_HISTORY

# Quicker navigation to sub dirs in most visited dirs
setopt auto_cd
cdpath=($HOME/dev)

# Use modern completion system
autoload -Uz compinit
compinit

# Set ps1 and include git branch
function parse_git_branch() {
  branch=$(git symbolic-ref --short HEAD 2> /dev/null)
  if [ ! -z $branch ]; then
    echo -n "$branch "
    if [ ! -z "$(git status --short)" ]; then
      echo "%F{15}[✗] "
    fi
  fi
}
setopt PROMPT_SUBST
PS1='%F{12}%~%f %F{13}$(parse_git_branch)%f$ '

# Import files
source ~/.alias
source ~/.functions
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
