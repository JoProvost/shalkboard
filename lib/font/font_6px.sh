#!/usr/bin/env bash
# Dependencies:
# - lib/terminal.sh

font_6px_print() {
  local x="$1" y="$2" color="$3" text="$4" font_i
  for (( font_i=0; font_i<${#text}; font_i++ )); do
    font_6px_write $((x)) $((y)) "$color" "${text:$font_i:1}"
    x=$((x + font_6px_width))
  done
}

font_6px_write() {
  local x="$1" y="$2" color="$3" char="$4"
  font_6px_width=5

  if [[ "$char" == 'A' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄  " \
      "██▄██ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'B' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄  " \
      "██▄█▀ " \
      "██▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'C' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄  " \
      "██ ▀▀ " \
      "▀█▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'D' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄  " \
      "██ ██ " \
      "██▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'E' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄▄ " \
      "██▄▄  " \
      "██▄▄▄ "
    font_6px_width=6
  elif [[ "$char" == 'F' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄▄ " \
      "██▄▄  " \
      "██    "
    font_6px_width=6
  elif [[ "$char" == 'G' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄  " \
      "██ ▀▀ " \
      "▀█▄██ "
    font_6px_width=6
  elif [[ "$char" == 'H' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "██▄██ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'I' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      " ██  " \
      "▄██▄ "
    font_6px_width=5
  elif [[ "$char" == 'J' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "  ▄▄▄ " \
      "   ██ " \
      "▀█▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'K' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "██▄█▀ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'L' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄    " \
      "██    " \
      "██▄▄▄ "
    font_6px_width=6
  elif [[ "$char" == 'M' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "█████ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'N' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄  " \
      "██ ██ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'O' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄  " \
      "██ ██ " \
      "▀█▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'P' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄  " \
      "██ ██ " \
      "██▀▀  "
    font_6px_width=6
  elif [[ "$char" == 'Q' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄  " \
      "██ ██ " \
      " ▀▀██ "
    font_6px_width=6
  elif [[ "$char" == 'R' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄  " \
      "██▄█▀ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'S' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄▄ " \
      "▀█▄▄  " \
      "▄▄▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'T' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      " ██  " \
      " ██  "
      font_6px_width=5
  elif [[ "$char" == 'U' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "██ ██ " \
      "▀█▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'V' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "██ ██ " \
      " ▀██▀ "
    font_6px_width=6
  elif [[ "$char" == 'W' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "██ ██ " \
      "██▀██ "
    font_6px_width=6
  elif [[ "$char" == 'X' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "▀█▄█▀ " \
      "██ ██ "
    font_6px_width=6
  elif [[ "$char" == 'Y' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄ ▄▄ " \
      "▀█▄██ " \
      " ▄▄█▀ "
    font_6px_width=6
  elif [[ "$char" == 'Z' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄▄ " \
      " ▄▄█▀ " \
      "██▄▄▄ "
    font_6px_width=6
  elif [[ "$char" == 'a' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█▄▄█ " \
      "█  █ "
  elif [[ "$char" == 'b' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      "█▄▄▀ " \
      "█▄▄▀ "
  elif [[ "$char" == 'c' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█  ▀ " \
      "▀▄▄▀ "
  elif [[ "$char" == 'd' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      "█  █ " \
      "█▄▄▀ "
  elif [[ "$char" == 'e' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      "█▄▄  " \
      "█▄▄▄ "
  elif [[ "$char" == 'f' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      "█▄▄  " \
      "█    "
  elif [[ "$char" == 'g' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█  ▀ " \
      "▀▄██ "
  elif [[ "$char" == 'h' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "█▄▄█ " \
      "█  █ "
  elif [[ "$char" == 'i' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      " █   " \
      "▄█▄  "
      font_6px_width=4
  elif [[ "$char" == 'j' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "  ▄▄ " \
      "   █ " \
      "▀▄▄▀ "
  elif [[ "$char" == 'k' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "█▄▄▀ " \
      "█  █ "
  elif [[ "$char" == 'l' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄    " \
      "█    " \
      "█▄▄▄ "
  elif [[ "$char" == 'm' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "████ " \
      "█  █ "
  elif [[ "$char" == 'n' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      "█  █ " \
      "█  █ "
  elif [[ "$char" == 'o' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█  █ " \
      "▀▄▄▀ "
  elif [[ "$char" == 'p' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      "█  █ " \
      "█▀▀  "
  elif [[ "$char" == 'q' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█  █ " \
      " ▀▀█ "
  elif [[ "$char" == 'r' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      "█▄▄▀ " \
      "█  █ "
  elif [[ "$char" == 's' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄▄ " \
      "▀▄▄  " \
      "▄▄▄▀ "
  elif [[ "$char" == 't' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄ " \
      " █  " \
      " █  "
      font_6px_width=4
  elif [[ "$char" == 'u' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "█  █ " \
      "▀▄▄▀ "
  elif [[ "$char" == 'v' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "█  █ " \
      " ▀█▀ "
  elif [[ "$char" == 'w' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "█  █ " \
      "█▀▀█ "
  elif [[ "$char" == 'x' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "▀▄▄▀ " \
      "█  █ "
  elif [[ "$char" == 'y' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "▀▄▄█ " \
      " ▄▄▀ "
  elif [[ "$char" == 'z' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      " ▄▄▀ " \
      "█▄▄▄ "
  elif [[ "$char" == '0' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█ ▄█ " \
      "▀█▄▀ "
  elif [[ "$char" == '1' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄  " \
      " █  " \
      "▄█▄ "
      font_6px_width=4
  elif [[ "$char" == '2' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      " ▄▄▀ " \
      "█▄▄▄ "
  elif [[ "$char" == '3' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄  " \
      " ▄▄▀ " \
      "▄▄▄▀ "
  elif [[ "$char" == '4' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄  ▄ " \
      "█▄▄█ " \
      "   █ "
  elif [[ "$char" == '5' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      "█▄▄  " \
      "▄▄▄▀ "
  elif [[ "$char" == '6' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "█▄▄  " \
      "▀▄▄▀ "
  elif [[ "$char" == '7' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "▄▄▄▄ " \
      "▀  █ " \
      "   █ "
  elif [[ "$char" == '8' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "▀▄▄▀ " \
      "▀▄▄▀ "
  elif [[ "$char" == '9' ]]; then
    terminal sprite "$x" "$y" "$color" \
      " ▄▄  " \
      "▀▄▄█ " \
      " ▄▄▀ "
  elif [[ "$char" == ' ' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "     " \
      "     " \
      "     "
  elif [[ "$char" == '_' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "     " \
      "     " \
      "▄▄▄▄ "
  elif [[ "$char" == '.' ]]; then
    terminal sprite "$x" "$y" "$color" \
      "     " \
      "     " \
      " ██  "
  fi
}
