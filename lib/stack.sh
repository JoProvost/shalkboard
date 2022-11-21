#!/usr/bin/env bash

# stack undo
stack_undo() {
  if [[ $((_stack_size)) -gt 0 ]]; then
    local last="${_stack[$((_stack_size - 1))]}"
    eval on_before_stack_undo $last
    if [[ "${last}" == *" #__REPLACED__"* ]]; then
      _stack[$((_stack_size - 1))]="${last#* #__REPLACED__}"
    else
      _stack_size=$((_stack_size - 1))
      unset _stack[$((_stack_size))]
    fi
    on_after_stack_undo
  fi
}

# stack peek
stack_peek() {
  if [[ $((_stack_size)) -gt 0 ]]; then
    echo "${_stack[$((_stack_size - 1))]}"
  fi
}

# stack rollback
stack_rollback() {
  if [[ $((_stack_size)) -gt 0 ]]; then
    unset _stack[$((--_stack_size))]
    if [[ $((_stack_size)) -gt 0 ]]; then
      local last="${_stack[$((_stack_size - 1))]}"
      while [[ $((_stack_size)) -gt 0 && "${last}" != *" #__COMMITTED__"* ]]; do
        unset _stack[$((--_stack_size))]
        if [[ $((_stack_size)) -gt 0 ]]; then
          local last="${_stack[$((_stack_size - 1))]}"
        fi
      done
    fi
    on_after_stack_rollback
  fi
}

# stack replay
stack_replay() {
  on_before_stack_replay
  eval "$(stack_save)"
}

# stack load
stack_load() {
  IFS=$'\r\n' GLOBIGNORE='*' command eval '_stack=($(cat))'
  _stack_size="${#_stack[@]}"
}

# stack save
stack_save() {
  printf '%s\n' "${_stack[@]}"
}

# stack push <command> [arguments...]
stack_push() {
  local quoted="$(_stack_quote "${@}")"
  if [[ $((_stack_size)) -eq 0 || "$quoted" != "${_stack[$((_stack_size - 1))]}" ]]; then
    _stack[$((_stack_size++))]="$quoted"
    eval "$quoted"
  fi
}

# stack replace <command> [arguments...]
stack_replace() {
  if [[ $((_stack_size)) -eq 0 ]]; then
    stack_push "${@}"
  else
    local last="${_stack[$((_stack_size - 1))]}"
    local quoted="$(_stack_quote "${@}") #__REPLACED__$last"
    _stack[$((_stack_size - 1))]="$quoted"
    eval "$quoted"
  fi
}

# stack commit
stack_commit() {
  if [[ $((_stack_size)) -gt 0 ]]; then
    local last="${_stack[$((_stack_size - 1))]}"
    if [[ "${last}" != *" #__COMMITTED__"* ]]; then
      _stack[$((_stack_size - 1))]="$last #__COMMITTED__"
    fi
  fi
}

# stack alter <command> [arguments...]
stack_alter() {
  if [[ $((_stack_size)) -eq 0 ]]; then
    stack_push "${@}"
  else
    local quoted="$(_stack_quote "${@}")"
    _stack[$((_stack_size - 1))]="$quoted"
    eval "$quoted"
  fi
}

# stack clear
stack_clear() {
  _stack=()
  _stack_size=0
}

_stack_quote() {
  local arg
  for arg; do echo -n "'${arg//\'/´}' "; done
}


on_before_stack_replay() { :; }
on_before_stack_undo() { :; }
on_after_stack_undo() { stack_replay; }
on_after_stack_rollback() { on_after_stack_undo; }


stack() {
  local action=$1; shift
  case $action in
    clear) stack_clear "$@" ;;
    replace) stack_replace "$@" ;;
    alter) stack_alter "$@" ;;
    push) stack_push "$@" ;;
    undo) stack_undo ;;
    peek) stack_peek ;;

    commit) stack_commit ;;
    rollback) stack_rollback ;;

    replay) stack_replay ;;
    load) stack_load ;;
    save) stack_save ;;
  esac
}

