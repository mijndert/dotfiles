export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH

bindkey "^R" history-incremental-search-backward

source ~/.alias
source ~/.functions

autoload -U colors
colors

setopt auto_cd
cdpath=($HOME/code)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit
compinit

function parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1) /";
}

setopt PROMPT_SUBST

PS1="%~ \$(parse_git_branch)\$ "
