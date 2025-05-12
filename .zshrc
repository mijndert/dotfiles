export EDITOR=vim
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

export HOMEBREW_NO_ANALYTICS=1
export RIPGREP_CONFIG_PATH=~/.ripgreprc

bindkey "^R" history-incremental-search-backward

setopt SHARE_HISTORY HIST_IGNORE_DUPS
SAVEHIST=5000
HISTFILE=~/.zsh_history

autoload -U promptinit; promptinit
autoload -Uz bashcompinit; bashcompinit
autoload -Uz compinit; compinit

zstyle :prompt:pure:git:stash show yes
prompt pure

complete -C '/opt/homebrew/bin/aws_completer' aws
complete -o nospace -C /usr/local/bin/terraform terraform

source ~/.alias
source ~/.functions
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)
eval "$(direnv hook zsh)"