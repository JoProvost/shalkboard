#!/usr/bin/env bash
trap 'echo -e "\033[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\033[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. terminal.sh
popd >/dev/null || true


# Writes text at the specified location without color, then placing cursor to bottom right
diff <(terminal write 10 20 "This is a test" | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "This is a test"
echo -ne "\033[1024;1024H"
) | cat -v)


# Writes text in green, resetting color attributes after
diff <(terminal write 10 20 "This is a test" green | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "\033[32m"
echo -ne "This is a test"
echo -ne "\033[0m"
echo -ne "\033[1024;1024H"
) | cat -v)


# Writes text in blue, resetting color attributes after
diff <(terminal write 10 20 "This is a test" blue | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "\033[34m"
echo -ne "This is a test"
echo -ne "\033[0m"
echo -ne "\033[1024;1024H"
) | cat -v)


# Writes text in red, resetting color attributes after
diff <(terminal write 10 20 "This is a test" red | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "\033[31m"
echo -ne "This is a test"
echo -ne "\033[0m"
echo -ne "\033[1024;1024H"
) | cat -v)


# Writes text in yellow, resetting color attributes after
diff <(terminal write 10 20 "This is a test" yellow | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "\033[33m"
echo -ne "This is a test"
echo -ne "\033[0m"
echo -ne "\033[1024;1024H"
) | cat -v)


# Writes text in white, resetting color attributes after
diff <(terminal write 10 20 "This is a test" white | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "\033[39m"
echo -ne "This is a test"
echo -ne "\033[0m"
echo -ne "\033[1024;1024H"
) | cat -v)


on_terminal_write() { echo on_terminal_write "$@" >&2; }
# Calls hook when writing line on screen
diff <(terminal write 10 20 "This  is  a  test" green 2>&1 1>/dev/null) <(
echo on_terminal_write 10 20 "This  is  a  test" green
)
on_terminal_write() { :; }


# Writes sprites in blue
diff <(terminal sprite 10 20 "blue" "line 1" "line 2" "line 3" | cat -v) <((
echo -ne "\033[34m"
echo -ne "\033[20;10H"
echo -ne "line 1"
echo -ne "\033[21;10H"
echo -ne "line 2"
echo -ne "\033[22;10H"
echo -ne "line 3"
echo -ne "\033[0m"
echo -ne "\033[1024;1024H"
) | cat -v)


# Writes sprites without color
diff <(terminal sprite 10 20 "" "line 1" "line 2" "line 3" | cat -v) <((
echo -ne "\033[20;10H"
echo -ne "line 1"
echo -ne "\033[21;10H"
echo -ne "line 2"
echo -ne "\033[22;10H"
echo -ne "line 3"
echo -ne "\033[1024;1024H"
) | cat -v)


on_terminal_write() { echo on_terminal_write "$@" >&2; }
# Calls hook when writing sprite on screen
diff <(terminal sprite 10 20 "green" "line 1" "line 2" "line 3" 2>&1 1>/dev/null) <(
echo on_terminal_write 10 20 "line 1" green
echo on_terminal_write 10 21 "line 2" green
echo on_terminal_write 10 22 "line 3" green
)
on_terminal_write() { :; }
