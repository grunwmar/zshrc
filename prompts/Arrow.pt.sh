#!/usr/bin/zsh

setopt prompt_subst
setopt extended_glob

NEWLINE=$'\n'
DOLLAR=$'$'
LBRACK=$'['
T_RES=$'%{\033[0m%}'

RIGHT_WIDGET_COLOR="%F{reset_color}"

DEF_COLOR_FG_L="%F{reset_color}"
DEF_COLOR_FG_D="%F{reset_color}"
ROOT_COLOR_FG_L="%F{reset_color}"
ROOT_COLOR_FG_D="%F{reset_color}"


function cl() {
  echo "%{\033[$1m%}"
}

function git_prompt_info() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match)
    local dirty_icon=""
    local dirty_color="${RIGHT_WIDGET_COLOR}"

    # Kontrola změn
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      dirty_icon="${RIGHT_WIDGET_COLOR} %f" # nebo např. ✚
    else
      dirty_icon=" "
      dirty_color="${RIGHT_WIDGET_COLOR}"
    fi

    local italic_on="%{\e[3m%}"
    local italic_off="%{\e[23m%}"

    echo "${dirty_color}%{\033[2m%}󰊢 ${branch}%{\033[0m%}${dirty_icon}%f%{\033[0m%} "
  else
    echo ""
  fi
}

function colored_path_widget() {
  local path="${PWD/#$HOME/~}" # Nahradí /home/uživatel → ~
  local slash_color="%f%(!.${ROOT_COLOR_FG_D}.${DEF_COLOR_FG_L})"
  local dir_color="%f%B"
  local reset="%b%f"

  local slash=""

  local formatted=""
  local component

  # Odstraníme úvodní lomítko, ale uložíme ho jako začátek
  [[ "$path" == /* ]] && formatted="󰋊 ${slash_color}${slash}${reset}"

  # Rozdělení na části přes lomítka
  IFS='/' read -A parts <<<"${path#/}"

  for component in "${parts[@]}"; do
    formatted+="${dir_color}${component}${reset}${slash_color} ${slash}${reset}"
  done

  # Odstraníme poslední lomítko
  formatted="${formatted%${slash_color} ${slash}${reset}}"

  echo -e "$formatted"
}

function venv_widget() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local env_name=$(basename "$VIRTUAL_ENV")
    local icon=" "
    local color="${RIGHT_WIDGET_COLOR}"

    echo -e "${color}%{\033[2m%}${icon}${env_name}%{\033[0m%}%f "
  fi
}

function clock_widget() {
  local hour=$(date +%H)
  local time=$(date +%H:%M)
  local color="${RIGHT_WIDGET_COLOR}"

  echo -e "${color}${time}%f"
}

function sshd_status() {
  if pgrep -x sshd >/dev/null; then
    echo -e " %{\033[2m%}%F{5}󰢹 %f%F{13}󰣀%f%{\033[0m%}"
  else
    echo -e ""
  fi
}

function prompt_sign() {
  if [[ "$EUID" == 0 ]]; then
    echo -e "%F{reset_color}%f"
  else
    echo -e "%F{reset_color}%f"
  fi
}

function user_name() {
  if [[ "$EUID" == 0 ]]; then
    echo -e "root"
  else
    echo -e "$USER"
  fi
}



function hostname_clr() {
  echo -e "${RIGHT_WIDGET_COLOR}%{\e[2m%}󰒍 $HOSTNAME%{\e[0m%}%f"
}


function system_icon_widget() {
  local os_id=""
  local icon="󰌽"  # fallback: Linux Tux

  if [[ -f /etc/os-release ]]; then
    os_id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
  else
    os_id=$(uname -s)
  fi

  case "$os_id" in
    arch)        icon="%F{14}" ;;  # Arch Linux
    debian)      icon="%F{13}" ;;
    ubuntu)      icon="%F{11}" ;;
    fedora)      icon="%F{12}" ;;
    nixos)       icon="%F{12}" ;;
    alpine)      icon="%F{14}" ;;
    
    centos)      icon="%F{13}" ;;
    linuxmint)      icon="%F{10}" ;;
    kali)      icon="%F{12}" ;;
    suse|opensuse)      icon="%F{10}" ;;
    manjaro)      icon="%F{10}" ;;
    zorin)      icon="%F{12}" ;;
    rhel)      icon="%F{9}" ;;

    android)     icon="%{10}" ;;  # Termux
    darwin|macos|Darwin) icon="" ;;
    linux)       icon="󰌽" ;;  # fallback
    termux|Termux)       icon="" ;;  # fallback
  esac
  
  echo -e "${icon}%f"
}


function precmd() {

  if [[ $COLUMNS -lt 100 ]]; then
    CONDITIONAL_BREAK="$NEWLINE"
  else
    CONDITIONAL_BREAK=" "
  fi

  STAT="$?"
  EXITC="%(?..%F{3} %?%f$NEWLINE)"
  PROMPT='$EXITC$NEWLINE$(system_icon_widget) ─$(user_name) $(hostname_clr)$NEWLINE├──$(colored_path_widget) $(git_prompt_info)$NEWLINE└──$(prompt_sign) '
  RPROMPT='$(venv_widget)$(sshd_status)$(clock_widget)'
}
