#!/usr/bin/env bash

source lib/terminal.sh
source lib/stack.sh
source lib/buffer.sh


shalkboard_clipboard_copy_start() {
  shalkboard_clipboard_selection_x="$1";
  shalkboard_clipboard_selection_y="$2";
  terminal write "$1" "$2" "◿"
}

shalkboard_clipboard_copy_end() {
  if [ "${shalkboard_clipboard_selection_x-}x" != "x" ]; then
    terminal write "$1" "$2" "◸"

    on_terminal_write() { buffer write "$@"; }
    on_terminal_clear() { buffer clear; }
    buffer clear
    stack replay
    IFS=$'\r\n' GLOBIGNORE='*' command eval 'shalkboard_clipboard=($(buffer copy "$shalkboard_clipboard_selection_x" "$shalkboard_clipboard_selection_y" "$1" "$2"))'
    on_terminal_write() { :; }
    on_terminal_clear() { :; }

    terminal write "$shalkboard_clipboard_selection_x" "$shalkboard_clipboard_selection_y" "◿"
    terminal write "$1" "$2" "◸"

    unset shalkboard_clipboard_selection_x
    unset shalkboard_clipboard_selection_y
  fi
}

shalkboard_clipboard_paste() {
  stack push terminal sprite "$@" "${shalkboard_clipboard[@]}"
  stack commit
}
