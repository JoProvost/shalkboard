#!/usr/bin/env bash

pushd "$(dirname -- "$0")" >/dev/null || exit 1
source lib/terminal.sh
source lib/toolbar.sh
source lib/stack.sh
source lib/buffer.sh
source shalkboard_text.sh
source shalkboard_draw.sh
source shalkboard_clipboard.sh
popd >/dev/null || true


on_mouse_press() {
  if ! toolbar_click $1 $2; then
    shalkboard_text_confirm
    case "$tool" in
      draw) shalkboard_draw_start "$1" "$2" "$brush" "$color" ;;
      text) shalkboard_text_start "$1" "$2" "$text_font" "$color" ;;
      copy) shalkboard_clipboard_copy_start "$@" ;;
      paste) shalkboard_clipboard_paste "$1" "$2" "$color" ;;
    esac
  fi
}

on_mouse_release() {
  case "$tool" in
    draw) shalkboard_draw_end "$@" ;;
    copy) shalkboard_clipboard_copy_end "$@" ;;
  esac
}

on_mouse_drag() {
  case "$tool" in
    draw) shalkboard_draw_mouse_drag $1 $2 ;;
  esac
}

on_key_arrow_left() {
  case "$tool" in
    draw) shalkboard_draw_left ;;
  esac
}

on_key_arrow_right() {
  case "$tool" in
    draw) shalkboard_draw_right ;;
  esac
}
on_key_arrow_up() {
  case "$tool" in
    draw) shalkboard_draw_up ;;
  esac
}
on_key_arrow_down() {
  case "$tool" in
    draw) shalkboard_draw_down ;;
  esac
}

on_key_type() {
  case "$tool" in
    text) shalkboard_text_type "$1" ;;
  esac
}

on_key_enter() {
  shalkboard_text_enter
}

on_key_backspace() { stack undo; stack commit; }

on_key_page_up() {
  shalkboard_change_page $((shalkboard_page_number - 1));
  toolbar_draw
}

on_key_page_down() {
  shalkboard_change_page $((shalkboard_page_number + 1));
  toolbar_draw
}

on_before_stack_undo() {
  shalkboard_draw_undo "$@"
  shalkboard_text_undo "$@"
}

on_after_stack_undo() { stack replay; toolbar_draw; shalkboard_text_refresh; }
on_after_stack_rollback() { shalkboard_clear_screen; stack replay; toolbar_draw ; shalkboard_text_refresh; }

shalkboard_clear_screen() {
  toolbar_clear_screen
  on_terminal_clear
}

shalkboard_clear_menu() {
  terminal clear-up "$toolbar_bottom_right_y"
  on_terminal_clear
}

on_key_delete() {
  stack rollback
}

on_toolbar_event() {
  tool_is() { [ "$tool" == "$1" ] && echo true || echo false; }
  brush_is() { [ "$brush" == "$1" ] && [ "$tool" == "draw" ] && echo true || echo false; }
  color_is() { [ "$color" == "$1" ] && echo true || echo false; }
  font_is() { [ "$text_font" == "$1" ] && [ "$tool" == "text" ] && echo true || echo false; }
  page_is() { [ "$shalkboard_page_number" == "$1" ] && echo true || echo false; }

  lite_menu() {
    toolbar_start ||
      toolbar_line_start ||
        toolbar_button "redraw" shalkboard_redraw ||
        toolbar_button "exit" "tool=exit; terminal mouse_off" "$(tool_is exit)" ||
        toolbar_button ">>>" "menu=extended" ||
        toolbar_spacer ||
        toolbar_label "page:" ||
        toolbar_button "1" "shalkboard_change_page 1" "$(page_is 1)" ||
        toolbar_button "2" "shalkboard_change_page 2" "$(page_is 2)" ||
        toolbar_button "3" "shalkboard_change_page 3" "$(page_is 3)" ||
        toolbar_button "4" "shalkboard_change_page 4" "$(page_is 4)" ||
        toolbar_button "5" "shalkboard_change_page 5" "$(page_is 5)" ||
        toolbar_button "6" "shalkboard_change_page 6" "$(page_is 6)" ||
        toolbar_button "7" "shalkboard_change_page 7" "$(page_is 7)" ||
        toolbar_button "8" "shalkboard_change_page 8" "$(page_is 8)" ||
        toolbar_button "9" "shalkboard_change_page 9" "$(page_is 9)" ||
      toolbar_line_end ||
    toolbar_end
  }

  extended_menu() {
    toolbar_start ||
      toolbar_line_start ||
        toolbar_button "redraw" shalkboard_redraw ||
        toolbar_button "exit" "tool=exit; terminal mouse_off" "$(tool_is exit)" ||
        toolbar_button "<<<" "menu=lite; shalkboard_clear_menu; stack replay" ||
        toolbar_spacer ||
        toolbar_label "page:" ||
        toolbar_button "1" "shalkboard_change_page 1" "$(page_is 1)" ||
        toolbar_button "2" "shalkboard_change_page 2" "$(page_is 2)" ||
        toolbar_button "3" "shalkboard_change_page 3" "$(page_is 3)" ||
        toolbar_button "4" "shalkboard_change_page 4" "$(page_is 4)" ||
        toolbar_button "5" "shalkboard_change_page 5" "$(page_is 5)" ||
        toolbar_button "6" "shalkboard_change_page 6" "$(page_is 6)" ||
        toolbar_button "7" "shalkboard_change_page 7" "$(page_is 7)" ||
        toolbar_button "8" "shalkboard_change_page 8" "$(page_is 8)" ||
        toolbar_button "9" "shalkboard_change_page 9" "$(page_is 9)" ||
      toolbar_line_end ||

      toolbar_line_start ||
        toolbar_button "undo" "stack rollback" ||
        toolbar_button "reset" "shalkboard_reset" ||
        toolbar_button "reload" shalkboard_load ||
        toolbar_button "save" shalkboard_save ||
        toolbar_spacer ||
        toolbar_button "copy" tool=copy "$(tool_is copy)" ||
        toolbar_button "paste" tool=paste "$(tool_is paste)" ||
      toolbar_line_end ||

      toolbar_line_start ||
        toolbar_label "color:" ||
        toolbar_button "red" color=red "$(color_is red)" ||
        toolbar_button "green" color=green "$(color_is green)" ||
        toolbar_button "yellow" color=yellow "$(color_is yellow)" ||
        toolbar_button "blue" color=blue "$(color_is blue)" ||
        toolbar_button "white" color=white "$(color_is white)" ||
      toolbar_line_end ||

      toolbar_line_start ||
        toolbar_label "draw:" ||
        toolbar_button "██" "brush=block; tool=draw" "$(brush_is block)" ||
        toolbar_button "▄█▀" "brush=brush; tool=draw" "$(brush_is brush)" ||
        toolbar_button "┏━┛" "brush=bold; tool=draw" "$(brush_is bold)" ||
        toolbar_button "┌─┘" "brush=thin; tool=draw" "$(brush_is thin)" ||
        toolbar_button "+-+" "brush=ascii; tool=draw" "$(brush_is ascii)" ||
        toolbar_spacer ||
        toolbar_button "  " "brush=eraser; tool=draw" "$(brush_is eraser)" ||
      toolbar_line_end ||

      toolbar_line_start ||
        toolbar_label "text:" ||
        toolbar_button "small" "text_font=small; tool=text" "$(font_is small)" ||
        toolbar_button "6px" "text_font=6px; tool=text" "$(font_is 6px)" ||
        toolbar_button "10px" "text_font=10px; tool=text" "$(font_is 10px)" ||
        toolbar_button "line" "text_font=line; tool=text" "$(font_is line)" ||
      toolbar_line_end ||
    toolbar_end
  }

  if [[ "$menu" == "extended" ]]; then
    extended_menu || return 1
  else
    lite_menu || return 1
  fi
}


on_mouse_move() { terminal cursor-move 1024 1024; terminal cursor-request-position; }

on_cursor_position() {
  if [[ "$shalkboard_width" != "$1" || "$shalkboard_height" != "$2" ]]; then
    shalkboard_redraw
    toolbar_draw
  fi

  shalkboard_width="$1"
  shalkboard_height="$2"
}

shalkboard_redraw() {
  shalkboard_clear_screen
  stack replay
}

shalkboard_save() {
  on_terminal_write() { buffer write "$@"; }
  on_terminal_clear() { buffer clear; }

  stack save >"$shalkboard_page_file"
  terminal clear
  stack replay
  buffer save >"${shalkboard_page_file}.txt"

  on_terminal_write() { :; }
  on_terminal_clear() { :; }
}

shalkboard_load() {
  if [ -f "${shalkboard_page_file}" ]; then
    stack load <"${shalkboard_page_file}"
    shalkboard_clear_screen
    stack replay
  fi
}

shalkboard_change_page() {
  #tool=""
  stack save >"$shalkboard_page_file"

  shalkboard_page_number="$1"
  if [[ "$shalkboard_page_number" == "1" ]]; then
    shalkboard_page_file="${shalkboard_file}"
  else
    shalkboard_page_file="${shalkboard_file%.*}.${shalkboard_page_number}.board"
  fi

  shalkboard_load
}

shalkboard_reset() {
  stack clear
  shalkboard_clear_screen
  brush=brush
  color=green
  text_font=line
  tool=draw
}

shalkboard() {
  brush=brush
  color=green
  text_font=line
  tool=
  shalkboard_page_number=1
  shalkboard_file="${1-default.board}"
  shalkboard_page_file="$shalkboard_file"

  terminal clear
  shalkboard_load
  toolbar_draw

  trap 'terminal cursor-move 1 1024; terminal mouse-off; terminal cursor-on' EXIT
  terminal cursor-off
  while true; do
    terminal mouse-on
    terminal cursor-move 1024 1024;
    terminal cursor-request-position
    terminal read;
    terminal mouse-off
    case "$tool" in
      exit) exit ;;
    esac;
  done
}



if [ "$(basename -s .sh "$0")" == "shalkboard" ]; then
  shalkboard "$@"
fi
