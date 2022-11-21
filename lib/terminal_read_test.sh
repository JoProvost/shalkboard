#!/usr/bin/env bash
trap 'echo -e "\e[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\e[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. terminal.sh
popd >/dev/null || true

on_mouse_press() { echo on_mouse_press "$@"; }
on_mouse_release() { echo on_mouse_release "$@"; }
on_mouse_move() { echo on_mouse_move "$@"; }
on_mouse_drag() { echo on_mouse_drag "$@"; }
on_mouse_wheel_up() { echo on_mouse_wheel_up "$@"; }
on_mouse_wheel_down() { echo on_mouse_wheel_down "$@"; }

on_key_arrow_up() { echo on_key_arrow_up "$@"; }
on_key_arrow_down() { echo on_key_arrow_down "$@"; }
on_key_arrow_right() { echo on_key_arrow_right "$@"; }
on_key_arrow_left() { echo on_key_arrow_left "$@"; }
on_key_home() { echo on_key_home "$@"; }
on_key_insert() { echo on_key_insert "$@"; }
on_key_delete() { echo on_key_delete "$@"; }
on_key_end() { echo on_key_end "$@"; }
on_key_page_up() { echo on_key_page_up "$@"; }
on_key_page_down() { echo on_key_page_down "$@"; }
on_key_enter() { echo on_key_enter "$@"; }
on_key_backspace() { echo on_key_backspace "$@"; }
on_key_type() { echo on_key_type "$@"; }

on_cursor_position() { echo on_cursor_position "$@"; }


ESC=$'\e'

# Parse mouse press
diff <(echo -n "${ESC}[<0;10;20M" | terminal read) - <<EQUALS
on_mouse_press 10 20
EQUALS


# Parsing split sequence
diff <(terminal read < <(echo -n "${ESC}[<0;1"); terminal read < <(echo -n "0;20M")) - <<EQUALS
on_mouse_press 10 20
EQUALS


# Parse mouse release
diff <(echo -n "${ESC}[<0;10;20m" | terminal read) - <<EQUALS
on_mouse_release 10 20
EQUALS


# Parse mouse drag
diff <(echo -n "${ESC}[<32;10;20M" | terminal read) - <<EQUALS
on_mouse_drag 10 20
EQUALS


# Damp mouse drag events
diff <(echo -n "${ESC}[<32;10;20M${ESC}[<32;10;20M${ESC}[<32;10;21M${ESC}[<32;10;21M${ESC}[<32;11;21M" | terminal read) - <<EQUALS
on_mouse_drag 10 20
on_mouse_drag 10 21
on_mouse_drag 11 21
EQUALS


# Avoid mouse drag after a press at the same position
diff <(echo -n "${ESC}[<0;10;20M${ESC}[<32;10;20M${ESC}[<32;10;21M" | terminal read) - <<EQUALS
on_mouse_press 10 20
on_mouse_drag 10 21
EQUALS


# Parse mouse move
diff <(echo -n "${ESC}[<35;10;20M" | terminal read) - <<EQUALS
on_mouse_move 10 20
EQUALS


# Damp mouse move events
diff <(echo -n "${ESC}[<35;10;20M${ESC}[<35;10;20M${ESC}[<35;10;21M${ESC}[<35;10;21M${ESC}[<35;11;21M" | terminal read) - <<EQUALS
on_mouse_move 10 20
on_mouse_move 10 21
on_mouse_move 11 21
EQUALS


# Parse mouse wheel up
diff <(echo -n "${ESC}[<64;10;20M" | terminal read) - <<EQUALS
on_mouse_wheel_up 10 20
EQUALS


# Parse mouse wheel down
diff <(echo -n "${ESC}[<65;10;20M" | terminal read) - <<EQUALS
on_mouse_wheel_down 10 20
EQUALS


# Parse cursor position
diff <(echo -n "${ESC}[20;10R" | terminal read) - <<EQUALS
on_cursor_position 10 20
EQUALS


# Parse enter key (receiving line field)
diff <(echo -en "\n" | terminal read) - <<EQUALS
on_key_enter
EQUALS


# Parse enter key (receiving carriage return)
diff <(echo -en "\r" | terminal read) - <<EQUALS
on_key_enter
EQUALS


# Parse backspace key
diff <(printf "\x7f" | terminal read) - <<EQUALS
on_key_backspace
EQUALS


# Parse arrow_up key
diff <(echo -n "${ESC}[A" | terminal read) - <<EQUALS
on_key_arrow_up
EQUALS


# Parse arrow_down key
diff <(echo -n "${ESC}[B" | terminal read) - <<EQUALS
on_key_arrow_down
EQUALS


# Parse arrow_right key
diff <(echo -n "${ESC}[C" | terminal read) - <<EQUALS
on_key_arrow_right
EQUALS


# Parse arrow_left key
diff <(echo -n "${ESC}[D" | terminal read) - <<EQUALS
on_key_arrow_left
EQUALS


# Parse home key
diff <(echo -n "${ESC}[1~" | terminal read) - <<EQUALS
on_key_home
EQUALS


# Parse insert key
diff <(echo -n "${ESC}[2~" | terminal read) - <<EQUALS
on_key_insert
EQUALS


# Parse delete key
diff <(echo -n "${ESC}[3~" | terminal read) - <<EQUALS
on_key_delete
EQUALS


# Parse end key
diff <(echo -n "${ESC}[4~" | terminal read) - <<EQUALS
on_key_end
EQUALS


# Parse page_up key
diff <(echo -n "${ESC}[5~" | terminal read) - <<EQUALS
on_key_page_up
EQUALS


# Parse page_down key
diff <(echo -n "${ESC}[6~" | terminal read) - <<EQUALS
on_key_page_down
EQUALS


# Parse typing sequence
diff <(echo "hello world" | terminal read) <(
echo 'on_key_type' 'h'
echo 'on_key_type' 'e'
echo 'on_key_type' 'l'
echo 'on_key_type' 'l'
echo 'on_key_type' 'o'
echo 'on_key_type' ' '
echo 'on_key_type' 'w'
echo 'on_key_type' 'o'
echo 'on_key_type' 'r'
echo 'on_key_type' 'l'
echo 'on_key_type' 'd'
echo 'on_key_enter'
)

