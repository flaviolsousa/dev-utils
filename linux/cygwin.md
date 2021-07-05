## Configure terminal-onload

```
notepad ~/.bash_profile
```

```
alias cd..='cd ..'
alias cd..1='cd ..'
alias cd..2='cd ../../'
alias cd..3='cd ../../../'
alias cd..4='cd ../../../../'
alias cd..5='cd ../../../../../'


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
```

---

## Configure git ssh

```
notepad ~/.ssh/config
```

```
Host github.com
 IdentityFile ~/.ssh/id_rsa
```
