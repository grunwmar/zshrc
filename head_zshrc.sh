#!/usr/bin/zsh

if ! [[ -d $ZUSER ]]; then
  mkdir $ZUSER
fi

zstyle ':completion:*' range 1000:100
setopt autocd
setopt auto_list
setopt auto_menu

export HISTFILE=$HOME/.zhistory
export HISTSIZE=10000000
export SAVEHIST=10000000

setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

export EDITOR=nvim

# Functions and aliases

function @help () {
    cat $ZDOT/help
}

# Activate python virtual-environment
function vactivate () {
    if [[ -f $1/bin/activate ]]; then
      . $1/bin/activate
      local FILE=$(readlink -e $1)
    fi
}

alias @zshrc="$EDITOR $HOME/.zshrc"
alias @aliases="$EDITOR $ZUSER/aliases"
alias @zinit="$EDITOR $ZUSER/zinit"

function @restart-zsh () {
  deactivate
  if [[ $1 = "-c" ]]; then
    clear
  fi
  exec zsh
}

alias ls="ls --color=yes"
alias la="ls -A"
alias ll="ls -lAh"
alias l="ls -lh"
alias vim=nvim
alias tmux="tmux -f $HOME/.z/conf/tmux.conf"

function py () {
    if [[ $1 = "-M" ]]; then
      python __main__.py
    else
      python $@
    fi
}

alias pym="py -M"

alias ginit="git init"
alias gadd="git add ."
alias gcom="git commit"
alias gcom-amend="git commit --amend"
alias gpush="git push"
alias gpushf="git push -f"
alias gpull="git pull"
alias gpullf="git pull -f"
alias gchout="git checkout"
alias gchoutb="git checkout -b"
alias gfetch="git fetch"


# Sourcing custom files
if [[ -f $ZUSER/aliases ]]; then
  . $ZUSER/.aliases
fi

if [[ -d $HOME/.local/bin ]]; then
    export PATH=$HOME/.local/bin:$PATH
fi

if [[ -d $HOME/.bin ]]; then
    export PATH=$HOME/.bin:$PATH
fi

# Source prompt style
PROMPT_FILE=$ZDOT/prompts/$(cat $ZDOT/active-prompt).pt.sh

if [[ -f $PROMPT_FILE ]]; then
  . $PROMPT_FILE
fi

function @set-prompt() {
  PROMPT_FILE=$ZDOT/prompts/$1.pt.sh

  if [[ -f $PROMPT_FILE ]]; then
    echo "$1" > $ZDOT/active-prompt
    . $PROMPT_FILE
  else
    echo "No prompt style file $PROMPT_FILE found."
  fi
}


if [[ -f $ZUSER/zinit ]]; then
  . $ZUSER/zinit
fi
