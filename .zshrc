export EDITOR=vim
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
export HOMEBREW_NO_ANALYTICS=1
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export BAT_THEME="Catppuccin Mocha"

setopt SHARE_HISTORY HIST_IGNORE_DUPS
SAVEHIST=50000
HISTFILE=~/.zsh_history

autoload -U promptinit; promptinit # Initialize the prompt system
autoload -Uz bashcompinit; bashcompinit # Enable bash completion
autoload -Uz compinit; compinit # Enable zsh completion

zstyle :prompt:pure:git:stash show yes
prompt pure

complete -C '/opt/homebrew/bin/aws_completer' aws

source ~/.alias
source ~/.functions
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

eval "$(direnv hook zsh)"