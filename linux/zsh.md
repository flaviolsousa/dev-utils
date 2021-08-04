## Alias

```
alias explore=nemo

alias portls='netstat -tulpn | grep '

alias update='sudo apt-get update && sudo apt-get -y autoremove && sudo apt-get -y upgrade '

alias loopbackon='pactl load-module module-loopback latency_msec=1'
alias loopbackoff='pactl unload-module module-loopback'

alias gogit='cd ~/Documents/git'
alias gsubfor='git submodule foreach'
alias gsubforgl='git submodule foreach git pull'
alias gsubforgst='git submodule foreach git status'
alias gsubforgp='git submodule foreach git push'
alias gsubforgco='git submodule foreach git checkout'

alias psudo='sudo env "PATH=$PATH"'
```

## Plugins

```
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  bgnotify
  command-not-found
  compleat
  dotenv
  pyenv
)
```

## Theme

#### powerlevel9k

```sh
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv command_execution_time status rvm)
```

## globalias

```sh
my-globalias() {
  zle _expand_alias
  zle expand-word
  # zle self-insert
  BUFFER="$BUFFER "
  CURSOR=$(($CURSOR + 1))
}
zle -N my-globalias

bindkey -M emacs "^ " my-globalias
bindkey -M viins "^ " my-globalias
```
