#!/usr/bin/env bash

TERMINAL_BLANK="$(printf ' %0.s' {1..1024})"

terminal_write() {
  local csi=$'\033['
  terminal_cursor_move "$1" "$2"
  [ -z "$4" ] || terminal_color "$4"
  echo -n "${3-}"
  [ -z "$4" ] || terminal_color reset
  terminal_cursor_move_bottom_right
  on_terminal_write "$@"
}

terminal_sprite() {
  local csi=$'\033[' x="$1" y="$2" color="$3" line
  shift; shift; shift
  [ -z "$color" ] || terminal_color "$color"
  for line; do
    terminal_cursor_move $((x)) $((y))
    echo -n "$line"
    on_terminal_write $((x)) $((y++)) "$line" "$color"
  done
  [ -z "$color" ] || terminal_color reset
  terminal_cursor_move_bottom_right
}

terminal_color() {
  local csi=$'\033['
  case "${1-}" in
    blue) echo -n "${csi}34m" ;;
    green) echo -n "${csi}32m" ;;
    yellow) echo -n "${csi}33m" ;;
    red) echo -n "${csi}31m" ;;
    white) echo -n "${csi}39m" ;;
    reset) echo -n "${csi}0m" ;;
    *) echo -n "${csi}0m" ;;
  esac
}

terminal_clear() {
  local csi=$'\033['
  if [ "$#" -ge 4 ];then
    local x=$1 y=$2 width=$3 height=$4
    for ((i=1; i <= height; i++)); do
      terminal_write $x $((y++)) "${TERMINAL_BLANK:0:$width}"
    done
  else
    echo -n "${csi}2J"
    on_terminal_clear
  fi
}

terminal_clear_right() {
  local csi=$'\033['
  terminal_cursor_move "$1" "$2"
  echo -n "${csi}0K"
  terminal_cursor_move_bottom_right
}

terminal_clear_left() {
  local csi=$'\033['
  terminal_cursor_move "$1" "$2"
  echo -n "${csi}1K"
  terminal_cursor_move_bottom_right
}

terminal_clear_down() {
  local csi=$'\033[' line="$1"
  terminal_cursor_move 1 "$line"
  echo -n "${csi}0J"
  terminal_cursor_move_bottom_right
  #on_terminal_clear
}

terminal_clear_up() {
  local csi=$'\033[' line="$1"
  terminal_cursor_move 1 "$line"
  echo -n "${csi}1J"
  terminal_cursor_move_bottom_right
  #on_terminal_clear
}

terminal_cursor_on() {
  local csi=$'\033['
  echo -n "${csi}?25h"
}

terminal_cursor_off() {
  local csi=$'\033['
  echo -n "${csi}?25l"
}

terminal_cursor_request_position() {
  local csi=$'\033['
  echo -n "${csi}6n"
}

terminal_cursor_move() {
  local csi=$'\033[' column=$1 line=$2
  echo -n "${csi}${line};${column}H"
}

terminal_cursor_move_bottom_right() {
  terminal_cursor_move 1024 1024
}

terminal_mouse_on() {
  local csi=$'\033['
  stty -echo
  echo -n "$csi?1006h" # Enable SGR Coordinates
  echo -n "$csi?1003h" # Enable All mouse coordinates on
}

terminal_mouse_off() {
  local csi=$'\033['
  echo -n "$csi?1006l" # Disable SGR Coordinates
  echo -n "$csi?1003l" # Disable All mouse coordinates on
  stty echo
}

terminal_read() {
  local esc=$'\033' backspace=$(printf "\x7f")

  while IFS= read -r -s -n 1 -t 1 code; do
    if [[ "$code" == $'\r' || "$code" == $'\n' || "$code" == "" ]]; then
      on_key_enter
    elif [[ "$code" == "$esc" ]]; then
      mouse_parse_buffer="$code"
    elif [[ "$mouse_parse_buffer" == "" ]]; then
      if [ "$code" = "$backspace" ]
        then on_key_backspace
        else on_key_type "$code"
      fi
    else
      mouse_parse_buffer="${mouse_parse_buffer}$code"
      if terminal_parse "$mouse_parse_buffer"; then mouse_parse_buffer=""; fi
    fi
  done
}

terminal_parse() {
  local csi=$'\033['

  if [[ "$1" =~ ^"$csi<0;"([0-9]*)';'([0-9]*)M$ ]]; then
    on_mouse_event "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" press
    return 0
  elif [[ "$1" =~ ^"$csi<0;"([0-9]*)';'([0-9]*)m$ ]]; then
    on_mouse_event "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" release
    return 0
  elif [[ "$1" =~ ^"$csi<32;"([0-9]*)';'([0-9]*)M$ ]]; then
    on_mouse_event "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" drag
    return 0
  elif [[ "$1" =~ ^"$csi<35;"([0-9]*)';'([0-9]*)M$ ]]; then
    on_mouse_event "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" move
    return 0
  elif [[ "$1" =~ ^"$csi<64;"([0-9]*)';'([0-9]*)M$ ]]; then
    on_mouse_event "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" wheel_up
    return 0
  elif [[ "$1" =~ ^"$csi<65;"([0-9]*)';'([0-9]*)M$ ]]; then
    on_mouse_event "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" wheel_down
    return 0
  elif [[ "$1" =~ ^"$csi"([0-9]*)';'([0-9]*)R$ ]]; then
    on_cursor_position "${BASH_REMATCH[2]}" "${BASH_REMATCH[1]}" # x y
    return 0

  elif [[ "$1" = "${csi}A" ]]; then on_key_arrow_up; return 0
  elif [[ "$1" = "${csi}B" ]]; then on_key_arrow_down; return 0
  elif [[ "$1" = "${csi}C" ]]; then on_key_arrow_right; return 0
  elif [[ "$1" = "${csi}D" ]]; then on_key_arrow_left; return 0
  elif [[ "$1" = "${csi}1~" ]]; then on_key_home; return 0
  elif [[ "$1" = "${csi}2~" ]]; then on_key_insert; return 0
  elif [[ "$1" = "${csi}3~" ]]; then on_key_delete; return 0
  elif [[ "$1" = "${csi}4~" ]]; then on_key_end; return 0
  elif [[ "$1" = "${csi}5~" ]]; then on_key_page_up; return 0
  elif [[ "$1" = "${csi}6~" ]]; then on_key_page_down; return 0

  else
    return 1
  fi
}

on_mouse_event() {
  case "$3" in
    press) on_mouse_press "$1" "$2" ;;
    release) on_mouse_release "$1" "$2" ;;
    wheel_up) on_mouse_wheel_up "$1" "$2" ;;
    wheel_down) on_mouse_wheel_down "$1" "$2" ;;
    move) if [[ "$terminal_mouse_x" != "$1" || "$terminal_mouse_y" != "$2" ]]; then on_mouse_move "$1" "$2"; fi ;;
    drag) if [[ "$terminal_mouse_x" != "$1" || "$terminal_mouse_y" != "$2" ]]; then on_mouse_drag "$1" "$2"; fi ;;
  esac
  terminal_mouse_x="$1"
  terminal_mouse_y="$2"
}

# Event handlers
on_mouse_press() { :; }
on_mouse_release() { :; }
on_mouse_move() { :; }
on_mouse_drag() { :; }
on_mouse_wheel_up() { :; }
on_mouse_wheel_down() { :; }
on_key_type() { :; }
on_key_arrow_up() { :; }
on_key_arrow_down() { :; }
on_key_arrow_left() { :; }
on_key_arrow_right() { :; }
on_key_home() { :; }
on_key_end() { :; }
on_key_insert() { :; }
on_key_delete() { :; }
on_key_backspace() { :; }
on_key_enter() { :; }
on_key_page_up() { :; }
on_key_page_down() { :; }
on_cursor_position() { :; }

on_terminal_clear() { :; }
on_terminal_write() { :; }

terminal() {
  local action=$1; shift
  case $action in
    write) terminal_write "$@" ;;
    sprite) terminal_sprite "$@" ;;
    color) terminal_color "$@" ;;
    clear) terminal_clear "$@" ;;
    clear-right) terminal_clear_right "$@" ;;
    clear-left) terminal_clear_left "$@" ;;
    clear-down) terminal_clear_down "$@" ;;
    clear-up) terminal_clear_up "$@" ;;
    cursor-on) terminal_cursor_on "$@" ;;
    cursor-off) terminal_cursor_off "$@" ;;
    cursor-move) terminal_cursor_move "$@" ;;
    cursor-request-position) terminal_cursor_request_position "$@" ;;
    mouse-on) terminal_mouse_on ;;
    mouse-off) terminal_mouse_off ;;
    read) terminal_read ;;
    loop) terminal_loop ;;
  esac
}

