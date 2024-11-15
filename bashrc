# Credit by drkna
# Colour code reference: https://misc.flogisoft.com/bash/tip_colors_and_formatting

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"\342\224\200\[\033[0;37m\]\")$(if [[ ${EUID} == 0 ]]; then echo '\[\033[101;92m\]root\[\033[49;31m\]\[\033[01;33m\]'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]'; fi)@\[\033[01;96m\]\h\[\033[0;31m\]//\[\033[0;92m\]\$(date +'%H:%M:%S %d%b%Y') \[\033[0;31m\][\[\033[0;34m\] \w \[\033[0;31m\]] \$(parse_git_branch)\r\n\342\224\224 \[\033[01;33m\]\\$ \[\033[0;39m\]"
    ;;
screen*)
    PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"\342\224\200\[\033[0;37m\]\")$(if [[ ${EUID} == 0 ]]; then echo '\[\033[101;92m\]root\[\033[49;31m\]\[\033[01;33m\]'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]'; fi)@\[\033[01;96m\]\h\[\033[0;31m\]//\[\033[0;92m\]\$(date +'%H:%M:%S %d%b%Y') \[\033[0;31m\][\[\033[0;34m\] \w \[\033[0;31m\]] \$(parse_git_branch)\r\n\342\224\224 \[\033[01;33m\]\\$ \[\033[0;39m\]"
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

### Please place your custom config below this line ###

alias m='mc -e'
alias dils='docker image ls'
alias dsh=~/dsh.sh
alias dbash=~/dbash.sh
alias dps="docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}\t{{.Command}}'"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -laht'
alias m='mc -e'

# docker
alias dsh=/opt/scripts/dsh.sh
alias dbash=/opt/scripts/dbash.sh
alias dils='docker image ls'
alias dps="docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}\t{{.Command}}'"
alias dip="docker inspect -f '{{.Name}} {{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}'"
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dl='docker logs -f'
alias dip="docker inspect --format '{{ .NetworkSettings.Networks.docker.IPAddress }}'"

# Kubernetes
export KUBE_EDITOR='mc -e'
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

function kps {
  (echo -e "NAMESPACE\tNAME\tREADY\tSTATUS\tRESTARTS\tAGE\tIP\tempty\tempty\tempty" && kubectl get pods -A -o wide --no-headers=true) | awk 'BEGIN { OFS="\t" } { $(NF-2)=""; $(NF-1)=""; $NF=""; print $0 }' | column -t
}

function klogs {
  if [ $1 ]; then
    out=$(kubectl get pod -A |grep $1 |head -n1)
    echo $out |awk -F ' ' '{print "Namespace: "$1"\nPod Name: "$2}'
    read -p '[*] Do you want to view this?'
    kubectl logs -f --since=24h -n $(echo $out |awk -F ' ' '{print $1}') $(echo $out |awk -F ' ' '{print $2}') ${@:2}
  else
    echo "Usage: klogs <pod_name> [extra args for {kubectl logs}]"
  fi
}

alias kc='kubectl'
#alias kps=' kubectl get pod -o wide -A'
alias kds='kubectl get deployments,daemonsets,statefulsets,replicasets -A'
alias kss='kubectl get svc -o wide -A'
alias kdesc='kubectl describe'
alias ke='bash -c "KUBE_EDITOR=\"mc -e\" kubectl edit"'
#alias klogs='kubectl logs -f --since=24h'
alias ceph-tool='kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='"'"'{.items[0].metadata.name}'"'"') bash'
alias kbash='bash /opt/scripts/kbash.sh'
alias ksh='bash /opt/scripts/ksh.sh'
alias krestart='kubectl rollout restart'
alias ktop='kc top pod -A --sort-by=memory'
