#!/usr/bin/env bash
# Dependencies:
# - lib/terminal.sh

TOOLBAR_STANDARD_LINE="$(printf '─%0.s' {1..1024})"
TOOLBAR_SELECTED_LINE="$(printf '━%0.s' {1..1024})"


toolbar_start() {
  toolbar_top_left_x=${1-1}
  toolbar_top_left_y=${2-1}
  if [[ "${toolbar_event-}" == draw ]]; then
    toolbar_width=0
    toolbar_height=0
  fi
  toolbar_line_next_to=$((toolbar_top_left_y))
  return 1;
}

toolbar_line_start() {
  toolbar_button_next_to=$((toolbar_top_left_x))
  toolbar_line_y=$((toolbar_line_next_to))
  return 1;
}

toolbar_line_end() {
  toolbar_width=$(( (toolbar_button_next_to - toolbar_top_left_x) > toolbar_width ? (toolbar_button_next_to - toolbar_top_left_x) : toolbar_width ))
  toolbar_height=$(( (toolbar_line_next_to - toolbar_top_left_y) > toolbar_height ? (toolbar_line_next_to - toolbar_top_left_y) : toolbar_height ))

  local margin_x=$((toolbar_button_next_to))
  local margin_y=$((toolbar_line_y))
  if [[ "${toolbar_event}" == draw ]]; then
    local width=1
    local height=$((toolbar_line_next_to - margin_y))
    terminal clear $margin_x $margin_y $width $height
  elif [[ "${toolbar_event}" == clear ]]; then
    local width=$((toolbar_top_left_x + toolbar_width - margin_x))
    local height=$((toolbar_line_next_to - margin_y))
    terminal clear $margin_x $margin_y $width $height
  fi

  return 1;
}

toolbar_end() {
  toolbar_bottom_right_x=$((toolbar_top_left_x + toolbar_width))
  toolbar_bottom_right_y=$((toolbar_top_left_y + toolbar_height))
  [[ "${toolbar_event-}" == click ]] && return 1 || return 0
}

toolbar_spacer() {
  local button_x=$((toolbar_button_next_to))
  local button_y=$((toolbar_line_y))
  local width=${1-1} height=$((toolbar_line_next_to - button_y))

  toolbar_button_next_to=$((button_x + width))
  toolbar_line_next_to=$((button_y + height))

  if [[ "${toolbar_event}" == draw ]]; then
    terminal clear $button_x $button_y $width $height
  fi
  return 1
}


toolbar_button() {
  local button_x=$((toolbar_button_next_to))
  local button_y=$((toolbar_line_y))
  local button_label=" $1 "
  local button_action="${2-true}" selected="${3-}"
  local width=$((${#button_label} + 2)) height=3

  local last_next_to=$((toolbar_button_next_to))
  toolbar_button_next_to=$((button_x + width))
  toolbar_line_next_to=$((button_y + height))

  if [[ ${toolbar_event-draw} == click ]]; then
    if [[ $((toolbar_click_x)) -ge $((button_x)) &&
      $((toolbar_click_x)) -lt $((button_x + width)) &&
      $((toolbar_click_y)) -ge $((button_y)) &&
      $((toolbar_click_y)) -lt $((button_y + height)) ]]; then
      eval $button_action
      toolbar_draw
      return 0
    else
      return 1
    fi
  else
    toolbar_draw_button $button_x $button_y $width $height "$button_label" "$selected"
    return 1
  fi
}

toolbar_label() {
  local button_x=$((toolbar_button_next_to))
  local button_y=$((toolbar_line_y))
  local button_label=" $1 "
  local width=$((${#button_label})) height=3

  local last_next_to=$((toolbar_button_next_to))
  toolbar_button_next_to=$((button_x + width))
  toolbar_line_next_to=$((button_y + height))

  if [[ "${toolbar_event}" == draw ]]; then
    toolbar_draw_label $button_x $button_y $width $height "$button_label"
  fi
  return 1
}

toolbar_draw_button() {
  if [[ ${6-} == "true" ]]; then
    local tl="┏"     tc="$TOOLBAR_SELECTED_LINE"  tr="┓"
    local  l="┃"  c="${5- }"  r="┃"
    local bl="┗"     bc="$TOOLBAR_SELECTED_LINE"  br="┛"
  else
    local tl="┌"     tc="$TOOLBAR_STANDARD_LINE"  tr="┐"
    local  l="│"  c="${5- }"  r="│"
    local bl="└"     bc="$TOOLBAR_STANDARD_LINE"  br="┘"
  fi

  local x=$1 y=$2
  local width=$(($3 - ${#tl} -${#tr}))
  local height=$(($4 - 2))

  terminal write $x $((y++)) "$tl${tc:0:$width}$tr" green
  for ((i=1; i <= $height; i++)); do
    terminal write $x $((y++)) "$l${c:0:$width}$r" green
  done
  terminal write $x $((y++)) "$bl${bc:0:$width}$br" green
}

toolbar_draw_label() {
  local x=$1 y=$2
  local width=$3
  local height=$(($4 - 2))

  terminal clear $x $((y++)) $width 1
  for ((i=1; i <= $height; i++)); do
    terminal write $x $((y++)) "${5- }" green
  done
  terminal clear $x $((y++)) $width 1
}


on_toolbar_event() { :; }

toolbar_draw() {
  toolbar_event=draw on_toolbar_event
}

toolbar_clear_screen() {
  toolbar_event=clear on_toolbar_event
  for ((y=1; y < toolbar_bottom_right_y; y++)); do
    terminal clear-right "$toolbar_bottom_right_x" $y
  done
  terminal clear-down "$toolbar_bottom_right_y"
  on_terminal_clear
}

toolbar_click() {
  toolbar_event=click toolbar_click_x=$1 toolbar_click_y=$2 on_toolbar_event
}
