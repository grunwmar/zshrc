#!/usr/bin/zsh

# ***** PREPARE ENVIRONMENT ********************************************************************************************
if [[ $1 = "--prepare" ]]; then

  ZPROFILE=$HOME/.zprofile
  ZSHENV=$HOME/.zshenv

  echo "#!/usr/bin/zsh/" > $ZSHENV
  echo "export ZDOTDIR="'$HOME' >> $ZSHENV
  echo "export ZCMD="'$HOME'"/.zcmd" >> $ZSHENV
  echo "export ZPROMPTS="'$HOME'"/.zprompts" >> $ZSHENV
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

  cp $0 $HOME/.zshrc

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

# ***** SET OTHER VARIABLES ********************************************************************************************
  if [[ $(which nvim &>/dev/null ; echo $?) ]]; then
    export EDITOR='nvim'
  elif [[ $(which vim &>/dev/null ; echo $?) ]]; then
    export EDITOR='vim'
  else
    export EDITOR='nano'
  fi

# ***** SOURCING PREDEFINED FUNCTIONS.ZSH/ALIASES.ZSH ******************************************************************
  # to quick activate virtual environment
  function vn () {
    if [[ $1 = "-l" ]]; then
      LAST_PATH="$(cat $ZDOTDIR/.lastvn)"
      . $LAST_PATH/bin/activate
    else
      if [[ -f $1/bin/activate ]]; then
        . $1/bin/activate
        FILE=$(readlink -e $1)
        echo $FILE > $ZDOTDIR/.lastvn
      fi
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

  # to quick open .zshrc file
  alias @zshrc="$EDITOR $ZDOTDIR/.zshrc"

  alias nano="nano -T4"
  alias vim=nvim
  alias n=nano
  alias v=vim
  # alias vi=vim

  # to change directory
  alias :doc="cd $HOME/Documents"
  alias :dow="cd $HOME/Downloads"

  # git aliases
  alias gadd="git add"
  alias gadda="git add ."
  alias gcho="git checkout"
  alias gchob="git checkout -b"
  alias gcom="git commit"
  alias gcoma="git commit --amend"
  alias gpus="git push"
  function gsqu () { # git rebase -i <after-this-commit> (HEAD~n)
    git rebase -i HEAD~$1
  }

# ***** SET PATH TO CUSTOM COMMANDS ************************************************************************************
  if [[ -d $ZCMD ]]; then
      PATH+=$PATH:$ZCMD
  fi

# ***** PLUGINS ********************************************************************************************************
  # installed plugins
  # load_plugin "zsh-autosuggestions"
  # load_plugin "zsh-syntax-highlighting"
  # load_plugin "zsh-autocomplete"

# ***** PROMPTS ********************************************************************************************************
  load_prompt "prompt6"
