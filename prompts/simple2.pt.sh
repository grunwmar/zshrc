#!/usr/bin/zsh


setopt prompt_subst

NEWLINE=$'\n'
DOLLAR=$'$'
LBRACK=$'['
T_RES=$'%{\033[0m%}'


function cl () {
    echo "%{\033[$1m%}"
}


function git_prompt_info() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match)
    local dirty_icon=""
    local dirty_color="%F{2}"

    # Kontrola změn
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
     dirty_icon="%F{10}%B^%b%f"  # nebo např. ✚
    else
      dirty_icon="%F{2}%f"
      dirty_color="%F{2}"
    fi

    local italic_on="%{\e[3m%}"
    local italic_off="%{\e[23m%}"

    echo "%{\033[2m%}git(${dirty_color}${italic_on}${branch}${italic_off}${dirty_icon}%f%{\033[2m%})%{\033[0m%} "
        else
    echo ""
    fi
}


function colored_path_widget() {
  local path="${PWD/#$HOME/~}"  # Nahradí /home/uživatel → ~
  local slash_color="%F{10}"
  local dir_color=""
  local reset="%f"

  local formatted=""
  local component

  # Odstraníme úvodní lomítko, ale uložíme ho jako začátek
  [[ "$path" == /* ]] && formatted="${slash_color}/${reset}"

  # Rozdělení na části přes lomítka
  IFS='/' read -A parts <<< "${path#/}"

  for component in "${parts[@]}"; do
    formatted+="${dir_color}${component}${reset}${slash_color}/${reset}"
  done

  # Odstraníme poslední lomítko
  formatted="${formatted%${slash_color}/${reset}}"

  echo -e "$formatted"
}


function venv_widget() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local env_name=$(basename "$VIRTUAL_ENV")
    local icon=""
    local color="%F{10}"

    echo -e "%{\033[2m%}venv(${color}${icon}${env_name}%f)%{\033[0m%}"
  fi
}



function clock_widget() {
  local hour=$(date +%H)
  local time=$(date +%H:%M)
  local color="%F{reset_color}"
  
  echo -e "${color}%F{reset_color}${time}%f"
}


function sshd_status() {
  if pgrep -x sshd >/dev/null; then
    echo -e " [%F{10}ssh%f]"
  else
    echo -e ""
  fi
}


function prompt_sign () {
  if [[ "$EUID" == 0 ]]; then
 	echo -e "%F{9}%B#>%b%f "
  else
	echo -e "%F{10}%B>%b%f "
  fi
} 


function hostname_clr () {
	echo -e "@$HOSTNAME"
}

function precmd() {

  if [[ $COLUMNS -lt 100  ]]; then
  	CONDITIONAL_BREAK="$NEWLINE"
	else
	CONDITIONAL_BREAK=" "
  fi

  STAT="$?"
  EXITC="%(?..%F{9}-%?-%f$NEWLINE)"
  USERN="%(!.%F{9}%n%f.%n)"

  PROMPT='$NEWLINE$LBRACK%F{10}%n%f$(hostname_clr)] $(colored_path_widget)$(prompt_sign)'

  RPROMPT='$(git_prompt_info)$(venv_widget)$(sshd_status) $(clock_widget)'
}

