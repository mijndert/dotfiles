export ZSH=~/.oh-my-zsh
export EDITOR=vim
export PATH=PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export VIRTUAL_ENV_DISABLE_PROMPT=

ZSH_THEME=""
plugins=(git osx cp aws docker docker-compose virtualenv)
DISABLE_MAGIC_FUNCTIONS=true
source $ZSH/oh-my-zsh.sh

alias ..="cd .."
alias ...="cd ../.."
alias dl="cd ~/Downloads"
alias dev="cd ~/dev"
alias cat="bat"
alias g="git"
alias h="history"
alias sud="sudo -i"
alias v="vim"
alias t="tmux -2"
alias aws="noglob aws"
alias awscred="source /Users/mijndert/dev/devops_library/scripts/credentials/aws_sts.sh"
alias dry="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_HOST=$DOCKER_HOST moncho/dry"
alias tunnel='sshuttle --dns --daemon --pidfile=/tmp/sshuttle.pid --remote=mijndert@ssh.jorijn.com 0/0'
alias tunnelx='[[ -f /tmp/sshuttle.pid ]] && kill $(cat /tmp/sshuttle.pid) && echo "SSH tunnel disconnected"'
alias l="ls -lF -G"
alias la="ls -laF -G"
alias lsd="ls -lF -G | grep --color=never '^d'"
alias ls="command ls -G"
alias grep='grep --color=auto '
alias sudo='sudo '
alias week='date +%V'
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias hosts='sudo nano /etc/hosts'
alias cp='cp -i'
alias mv='mv -i'
alias pw='cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c$1'
alias pullall='find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull \;'
alias tf="terraform"

dupdate(){
	docker images | awk '/^REPOSITORY|\<none\>/ {next} {print $1}' | xargs -n 1 docker pull
}
dcleanup(){
	docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
	docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -U promptinit; promptinit
prompt pure

