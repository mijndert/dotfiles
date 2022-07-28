export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=$HOMEBREW_DIR/opt/python@3.9/libexec/bin:$HOMEBREW_DIR/bin:/usr/local/bin:/usr/local/sbin:$PATH
export GPG_TTY=$(tty)
export DOCKER_BUILDKIT=1

bindkey "^R" history-incremental-search-backward

autoload -U colors
colors

SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY

setopt auto_cd
cdpath=($HOME/dev)

autoload -Uz compinit
compinit

function detect_ssh() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo "→ "
  else
    exit
  fi
}
function parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1 /";
}
setopt PROMPT_SUBST
PS1='$(detect_ssh)%F{33}%~%f $(parse_git_branch)$ '

source ~/.alias
source ~/.functions
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
