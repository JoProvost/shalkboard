#!/usr/bin/env bash

source lib/terminal.sh
source lib/stack.sh
source lib/font/font_line.sh
source lib/font/font_6px.sh
source lib/font/font_10px.sh


shalkboard_text_start() {
  stack commit
  stack replay
  stack push shalkboard_text "$1" "$2" "$3" "$4" ""
  _shalkboard_text "$1" "$2" "$3" "$4" "_"
}

shalkboard_text_confirm() {
  # shellcheck disable=SC2046
  eval set -- $(stack peek)
  if [ "$1" == "shalkboard_text" ]; then
    shalkboard_text "$2" "$3" "$4" "$5" "${6} "
    stack replay
  fi
}

shalkboard_text_undo() {
  if [ "$1" == "shalkboard_text" ]; then
    shalkboard_text "$2" "$3" "$4" "$5" "${6%?}"
    _shalkboard_text "$2" "$3" "$4" "$5" "${6%?}  "
  fi
}

shalkboard_text_refresh() {
  # shellcheck disable=SC2046
  eval set -- $(stack peek)
  if [ "$1" == "shalkboard_text" ]; then
    _shalkboard_text "$2" "$3" "$4" "$5" "${6}_"
  fi
}


shalkboard_text_enter() {
  # shellcheck disable=SC2046
  eval set -- $(stack peek)
  if [ "$1" == "shalkboard_text" ]; then
    _shalkboard_text "$2" "$3" "$4" "$5" "$6 "
    case "$4" in
      small) shalkboard_text_start "$2" $(($3 + 1)) "$4" "$5" "" ;;
      6px) shalkboard_text_start "$2" $(($3 + 3)) "$4" "$5" "" ;;
      10px) shalkboard_text_start "$2" $(($3 + 5)) "$4" "$5" "" ;;
      line) shalkboard_text_start "$2" $(($3 + 6)) "$4" "$5" "" ;;
    esac
 fi
}

shalkboard_text_type() {
  stack replace shalkboard_text \
    "$shalkboard_text_x" \
    "$shalkboard_text_y" \
    "$shalkboard_text_font" \
    "$shalkboard_text_color" \
    "$shalkboard_text$1"
  _shalkboard_text \
    "$shalkboard_text_x" \
    "$shalkboard_text_y" \
    "$shalkboard_text_font" \
    "$shalkboard_text_color" \
    "${shalkboard_text}_"
}

shalkboard_text() {
  shalkboard_text_x="$1"
  shalkboard_text_y="$2"
  shalkboard_text_font="$3"
  shalkboard_text_color="$4"
  shalkboard_text="$5"

  _shalkboard_text \
    "$shalkboard_text_x" \
    "$shalkboard_text_y" \
    "$shalkboard_text_font" \
    "$shalkboard_text_color" \
    "$shalkboard_text"
}

_shalkboard_text() {
  case "$3" in
    small) terminal write "$1" "$2" "$5" "$4" ;;
    6px) font_6px_print "$1" "$2" "$4" "$5" ;;
    10px) font_10px_print "$1" "$2" "$4" "$5" ;;
    line) font_line_print "$1" "$2" "$4" "$5" ;;
    # legacy
    pixel) font_10px_print "$1" "$2" "$4" "$5" ;;
  esac
}


