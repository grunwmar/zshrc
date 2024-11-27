#!/usr/bin/zsh

# ***** PREPARE ENVIRONMENT ********************************************************************************************
if [[ $1 = "--prepare" ]]; then

  if [[ $(which zsh &>/dev/null ; echo $?) ]]; then
    echo "Can't find z-shell executable."
    exit 1
  fi

  ZPROFILE=$HOME/.zprofile
  ZSHENV=$HOME/.zshenv

  SET_ZDOTDIR="$HOME"
  SET_ZCMD="$HOME/.zcmd/"

  echo -n "Set ZDOTDIR directory (default is $SET_ZDOTDIR/) [y/n] "
  read ASK_ZDOTDIR

  if [[ $ASK_DOTDIR = "y" ]]; then
    echo "  New ZDOTDIR path: "
    read AKS_ZDOTDIR_VALUE
    SET_ZDOTDIR=$AKS_ZDOTDIR_VALUE
  fi

  echo -n "Set ZCMD directory (default is $SET_ZCMD) [y/n] "
  read ASK_ZCMD

  if [[ $ASK_ZCMD = "y" ]]; then
    echo "  New ZCMD path: "
    read AKS_ZCMD_VALUE
    SET_ZCMD=$AKS_ZDOTDIR_VALUE
  fi


  echo "#!/usr/bin/zsh/" > $ZSHENV
  echo "ZDOTDIR=$SET_ZDOTDIRE" >> $ZSHENV
  echo "ZCMD=$SET_ZCMD" >> $ZSHENV
  echo 'ZPROMPTS=$ZDOTDIR/zprompts' >> $ZSHENV
  echo '' >> $ZSHENV
  echo '# checks' >> $ZSHENV
  echo 'if ! [[ -d $ZDOTDIR ]]; then' >> $ZSHENV
  echo '  mkdir -p $ZDOTDIR' >> $ZSHENV
  echo 'fi' >> $ZSHENV
  echo '' >> $ZSHENV
  echo 'if ! [[ -d $ZCMD ]]; then' >> $ZSHENV
  echo '  mkdir -p $ZCMD' >> $ZSHENV
  echo 'fi' >> $ZSHENV
  echo '' >> $ZSHENV
  echo 'if ! [[ -d $ZPROMPTS ]]; then' >> $ZSHENV
  echo '  mkdir -p $ZPROMPTS' >> $ZSHENV
  echo 'fi' >> $ZSHENV
  echo '#!/usr/bin/zsh' >> $ZPROFILE

  mv "$0" "$(basename $0)/.zshrc"

  exit 0
fi

# ***** SETTING UP HISTORY *********************************************************************************************
  export HISTFILE=$HOME/.zhistory
  export HISTFILESIZE=10000
  export SAVEHIST=10000
  setopt extended_history hist_expire_dups_first hist_ignore_dups
  setopt hist_ignore_space hist_verify share_history inc_append_history

# ***** ADDITIONAL OPTIONS TO SET **************************************************************************************
  zstyle ':completion:*' range 1000:100
  setopt autocd
  setopt auto_list
  setopt auto_menu

# ***** SOURCING PREDEFINED FUNCTIONS.ZSH/ALIASES.ZSH ******************************************************************
  # to quick activate virtual environment
  function vn () {
    if [[ -f $1/bin/activate ]]; then
      . $1/bin/activate
    fi
  }

  # to turn off computer
  function pcoff() {
      echo -n "Turn off the computer? [y/N] "
      read ANSW
      if [[  $ANSW = y ]]; then
        sudo shutdown now
      fi
  }

  # to load custom prompt
  function load_prompt () {
      . $ZPROMPTS/$1
  }

  # to load plugin
  function load_plugin () {
    . $ZPROMPTS/$1/$1.plugin.zsh
  }

  # to change directory
  alias ..="cd .."
  alias bk="cd -"

  # to ist content of directory
  alias ls="ls --color=yes"
  alias la="ls -A"
  alias ll="ls -lAh"
  alias l="ls -lh"

  # to quick open .zshrc and aliases.sh file
  alias @zshrc="$EDITOR $ZDOTDIR/.zshrc"

  # alias nano="nano -T4"
  alias vim=nvim
  alias n=nano
  alias v=vim

  # to change directory
  alias :tasks="cd $HOME/Tasks"
  alias :work=":tasks"
  alias :doc="cd $HOME/Documents"
  alias :dow="cd $HOME/Downloads"

  # git aliases
  alias gadd="git add"
  alias gada="git add ."
  alias gcmt="git commit"
  alias gcma="git commit --amend"
  alias gpsh="git push"
  function gsqs () { # git rebase -i <after-this-commit> (HEAD~n)
    git rebase -i HEAD~$1
  }

# ***** SET PATH TO CUSTOM COMMANDS ************************************************************************************
  ZCMD=HOME/.zcmd
  if [[ -d $ZCMD ]]; then
      PATH+=$PATH:$HOME/.zcmd
  else
      mkdir -p $ZCMD
  fi

# ***** PLUGINS ********************************************************************************************************
  # installed plugins
  # load_plugin "zsh-autosuggestions"
  # load_plugin "zsh-syntax-highlighting"
  # load_plugin "zsh-autocomplete"

# ***** PROMPTS ********************************************************************************************************
  load_prompt "prompt6"
  clear
