#!/usr/bin/env bash

source lib/terminal.sh
source lib/stack.sh


shalkboard_draw_start() {
  shalkboard_draw_x="$1"
  shalkboard_draw_y="$2"
  shalkboard_draw_direction=""
  shalkboard_draw_pen=down
  brush="$3"
  color="$4"
  stack commit
  stack push shalkboard_glyph "$1" "$2" "$brush" "" "$color"
}

shalkboard_draw_undo() {
  if [ "$1" == "shalkboard_glyph" ]; then
    shalkboard_glyph "$2" "$3" "eraser" "$5"
  fi
}

shalkboard_draw_end() {
  if [ "$shalkboard_draw_pen" == down ]; then
    shalkboard_draw_pen=up
    stack commit
  fi
}

shalkboard_draw_left() {
  shalkboard_draw $((shalkboard_draw_x - 1)) $((shalkboard_draw_y))
}

shalkboard_draw_right() {
  shalkboard_draw $((shalkboard_draw_x + 1)) $((shalkboard_draw_y))
}

shalkboard_draw_up() {
  shalkboard_draw $((shalkboard_draw_x)) $((shalkboard_draw_y - 1))
}

shalkboard_draw_down() {
  shalkboard_draw $((shalkboard_draw_x)) $((shalkboard_draw_y + 1))
}

shalkboard_draw_mouse_drag() {
  if [ "$shalkboard_draw_pen" == down ]; then
    shalkboard_draw $1 $2
  fi
}

shalkboard_draw() {
  local delta_x=$(($1 - shalkboard_draw_x))
  if [[ $delta_x -gt 1 ]]; then shalkboard_draw $(($1 - 1)) $2; fi
  if [[ $delta_x -lt -1 ]]; then shalkboard_draw $(($1 + 1)) $2; fi

  local delta_y=$(($2 - shalkboard_draw_y))
  if [[ $delta_y -gt 1 ]]; then shalkboard_draw $1 $(($2 - 1)); fi
  if [[ $delta_y -lt -1 ]]; then shalkboard_draw $1 $(($2 + 1)); fi

  local delta_x=$(($1 - shalkboard_draw_x))
  local delta_y=$(($2 - shalkboard_draw_y))
  if [[ ${delta_x#-} -eq 1 && ${delta_y#-} -eq 1 ]]; then shalkboard_draw $(($1 - $delta_x)) $2; fi

  local x=$shalkboard_draw_x y=$shalkboard_draw_y
  local delta_x=$(($1 - x)) delta_y=$(($2 - y))
  case $delta_x,$delta_y in
    1,0) local direction=right ;;
    -1,0) local direction=left ;;
    0,1) local direction=down ;;
    0,-1) local direction=up ;;
  esac

  local altered_direction="${shalkboard_draw_direction:-${direction}}${direction/#/_}"
  stack alter shalkboard_glyph "$x" "$y" "$brush" "$altered_direction" "$color"
  stack push shalkboard_glyph "$1" "$2" "$brush" "$direction" "$color"
}


shalkboard_glyph() {
  local style="$3"
  local name="$4"
  local color="$5"
  local glyph_variable_name="glyph_${style}${name/#/_}"

  while [ -z "${!glyph_variable_name+x}" ]; do
    glyph_variable_name=${glyph_variable_name%_*}
  done

  terminal_write "$1" "$2" "${!glyph_variable_name}" "$color"

  shalkboard_draw_x=$1
  shalkboard_draw_y=$2
  shalkboard_draw_direction="$4"
}

glyph_eraser="  "

glyph_block="██"

glyph_brush="██"
glyph_brush_right_down="█▄"
glyph_brush_right_up="█▀"
glyph_brush_left_down="▄█"
glyph_brush_left_up="▀█"
glyph_brush_down_right="▀█"
glyph_brush_down_left="█▀"
glyph_brush_up_right="▄█"
glyph_brush_up_left="█▄"

glyph_bold="▪"
glyph_bold_right="━"
glyph_bold_right_down="┓"
glyph_bold_right_up="┛"
glyph_bold_left="━"
glyph_bold_left_down="┏"
glyph_bold_left_up="┗"
glyph_bold_down="┃"
glyph_bold_down_right="┗"
glyph_bold_down_left="┛"
glyph_bold_up="┃"
glyph_bold_up_right="┏"
glyph_bold_up_left="┓"

glyph_thin="▪"
glyph_thin_right="─"
glyph_thin_right_down="┐"
glyph_thin_right_up="┘"
glyph_thin_left="─"
glyph_thin_left_down="┌"
glyph_thin_left_up="└"
glyph_thin_down="│"
glyph_thin_down_right="└"
glyph_thin_down_left="┘"
glyph_thin_up="│"
glyph_thin_up_right="┌"
glyph_thin_up_left="┐"

glyph_ascii="+"
glyph_ascii_right="-"
glyph_ascii_right_down="+"
glyph_ascii_right_up="+"
glyph_ascii_left="-"
glyph_ascii_left_down="+"
glyph_ascii_left_up="+"
glyph_ascii_down="|"
glyph_ascii_down_right="+"
glyph_ascii_down_left="+"
glyph_ascii_up="|"
glyph_ascii_up_right="+"
glyph_ascii_up_left="+"

