#!/usr/bin/env bash

# buffer clear <x> <y> <text>
buffer_clear() {
  _buffer=()
}

# buffer write <x> <y> <text>
buffer_write() {
  local index=$(($2 - 1))
  local line="${_buffer[$index]}"

  if [[ ${#line} -lt $1 ]]
    then line="$line$(_buffer_repeat " " $(($1 - ${#line})) )"
  fi

  if [[ $2 -gt ${#_buffer[@]} ]]; then
    local i
    for ((i=${#_buffer[@]}; i <= index; i++)); do
      _buffer+=("")
    done
  fi

  if [[ $1 -gt 0 ]]
    then _buffer[$index]="${line:0:$(($1 - 1))}$3${line:$(($1 + ${#3} -1)):1000}"
    else _buffer[$index]="$3${line:$(($1 + ${#3} - 1)):1000}"
  fi
}

buffer_save() {
  printf "%s\n" "${_buffer[@]}"
}

buffer_copy() {
  local start_x=$1 start_y=$2 end_x=$3 end_y=$4
  local buffer_copy_line i
  for ((i=start_y - 1; i < end_y; i++)); do
    buffer_copy_line="${_buffer[$i]}"
    echo "${buffer_copy_line:$((start_x - 1)):$((end_x - start_x + 1))}"
  done
}

_buffer_repeat() {
  if [[ ${2-0} -gt 0 && ${#1} -lt $2 ]]
    then eval printf \""$1"\"'%0.s' {1..$2}
    else echo -n "$1"
  fi
}


buffer() {
  local action=$1; shift
  case $action in
    clear) buffer_clear "$@" ;;
    write) buffer_write "$@" ;;
    copy) buffer_copy "$@" ;;
    save) buffer_save ;;
  esac
}

