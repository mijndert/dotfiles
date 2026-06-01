export EDITOR=vim
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:$PATH
export HOMEBREW_NO_ANALYTICS=1
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export BAT_THEME="Catppuccin Mocha"
export K9S_CONFIG_DIR=~/.config/k9s

setopt SHARE_HISTORY HIST_IGNORE_DUPS
SAVEHIST=50000
HISTFILE=~/.zsh_history

fpath+=(/opt/homebrew/share/zsh/site-functions)

autoload -U promptinit; promptinit # Initialize the prompt system
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qNmh-24) ]]; then
  compinit -C
else
  compinit
fi
autoload -Uz bashcompinit; bashcompinit 

export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}

zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:dirty detailed yes
prompt pure

complete -C '/opt/homebrew/bin/aws_completer' aws

source ~/.alias
source ~/.functions
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

eval "$(direnv hook zsh)"
