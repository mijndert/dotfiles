export EDITOR=vim
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

export DOCKER_BUILDKIT=1
export HOMEBREW_NO_ANALYTICS=1
export TFENV_ARCH=amd64
export BAT_THEME="Solarized (dark)"
export RIPGREP_CONFIG_PATH=~/.ripgreprc

bindkey "^R" history-incremental-search-backward

setopt SHARE_HISTORY HIST_IGNORE_DUPS
SAVEHIST=5000
HISTFILE=~/.zsh_history

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
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
