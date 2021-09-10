```
xed ~/.bashrc
```

# Util:

### My user

```sh
#-------------------
export JAVA_HOME=/usr/lib/jvm/default-java

export M2_HOME=/usr/share/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH


export ORACLE_HOME=$HOME/Oracle/Oracle12c/osb
export MDS_PATH=$HOME/Documents/git/GTW_DEFINITIONS
export PS1="\W > "

alias cd..='cd ..'
alias cd..1='cd ..'
alias cd..2='cd ../../'
alias cd..3='cd ../../../'
alias cd..4='cd ../../../../'
alias cd..5='cd ../../../../../'

alias portls='netstat -tulpn | grep '

alias update='sudo apt-get update && sudo apt-get -y autoremove && sudo apt-get autoclean && sudo apt-get -y upgrade'

alias svpn='cat /etc/resolv.conf'
alias cvpn='echo -e "\nnameserver 172.16.20.10\nnameserver 172.16.20.11\n\n\n$(< /etc/resolv.conf)" | sudo tee /etc/resolv.conf && svpn'

alias ga='git add'
alias gaa='git add .'
alias gbr='git branch -v'
alias gbrl='git branch --set-upstream-to=origin/$(git rev-parse --abbrev-ref HEAD) $(git rev-parse --abbrev-ref HEAD)'
alias gc='git commit'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcod='git checkout develop'
alias gfa='git fetch --all'
alias gp='git pull'
alias gpa='git pull --all'
alias gpu='git push'
alias gs='git status'
alias gsv='git status -vv'

alias psudo='sudo env "PATH=$PATH"'

bind 'set completion-ignore-case on'
#-------------------
```

### Root

```sh
bind 'set completion-ignore-case on'
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\W> \[\033[00m\] '


export ORACLE_HOME=$HOME/Oracle/Oracle12c/osb
export MDS_PATH=$HOME/Documents/git/GTW_DEFINITIONS
```
