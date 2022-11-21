#!/usr/bin/env bash
trap 'echo -e "\033[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\033[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. ../terminal.sh
. ../buffer.sh
. font_6px.sh
popd >/dev/null || true


on_terminal_write() {
  buffer write "$@"
}

buffer clear

font_6px_print 2 1 ""  "ABCDEFGHIJKLMNOPQR" >/dev/null
font_6px_print 2 4 ""  "STUVWXYZ _." >/dev/null
font_6px_print 2 7 ""  "abcdefghijklmnopqr" >/dev/null
font_6px_print 2 10 ""  "stuvwxyz0123456789" >/dev/null

# Prints all letters
diff <(buffer save) <(
echo "  ▄▄▄  ▄▄▄▄   ▄▄▄  ▄▄▄▄  ▄▄▄▄▄ ▄▄▄▄▄  ▄▄▄  ▄▄ ▄▄ ▄▄▄▄   ▄▄▄ ▄▄ ▄▄ ▄▄    ▄▄ ▄▄ ▄▄▄▄   ▄▄▄  ▄▄▄▄   ▄▄▄  ▄▄▄▄  "
echo " ██▄██ ██▄█▀ ██ ▀▀ ██ ██ ██▄▄  ██▄▄  ██ ▀▀ ██▄██  ██     ██ ██▄█▀ ██    █████ ██ ██ ██ ██ ██ ██ ██ ██ ██▄█▀ "
echo " ██ ██ ██▄█▀ ▀█▄█▀ ██▄█▀ ██▄▄▄ ██    ▀█▄██ ██ ██ ▄██▄ ▀█▄█▀ ██ ██ ██▄▄▄ ██ ██ ██ ██ ▀█▄█▀ ██▀▀   ▀▀██ ██ ██ "
echo "  ▄▄▄▄ ▄▄▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄ ▄▄▄▄▄                "
echo " ▀█▄▄   ██  ██ ██ ██ ██ ██ ██ ▀█▄█▀ ▀█▄██  ▄▄█▀                "
echo " ▄▄▄█▀  ██  ▀█▄█▀  ▀██▀ ██▀██ ██ ██  ▄▄█▀ ██▄▄▄      ▄▄▄▄  ██  "
echo "  ▄▄  ▄▄▄   ▄▄  ▄▄▄  ▄▄▄▄ ▄▄▄▄  ▄▄  ▄  ▄ ▄▄▄   ▄▄ ▄  ▄ ▄    ▄  ▄ ▄▄▄   ▄▄  ▄▄▄   ▄▄  ▄▄▄  "
echo " █▄▄█ █▄▄▀ █  ▀ █  █ █▄▄  █▄▄  █  ▀ █▄▄█  █     █ █▄▄▀ █    ████ █  █ █  █ █  █ █  █ █▄▄▀ "
echo " █  █ █▄▄▀ ▀▄▄▀ █▄▄▀ █▄▄▄ █    ▀▄██ █  █ ▄█▄ ▀▄▄▀ █  █ █▄▄▄ █  █ █  █ ▀▄▄▀ █▀▀   ▀▀█ █  █ "
echo "  ▄▄▄ ▄▄▄ ▄  ▄ ▄  ▄ ▄  ▄ ▄  ▄ ▄  ▄ ▄▄▄▄  ▄▄  ▄▄  ▄▄▄  ▄▄▄  ▄  ▄ ▄▄▄▄  ▄▄  ▄▄▄▄  ▄▄   ▄▄  "
echo " ▀▄▄   █  █  █ █  █ █  █ ▀▄▄▀ ▀▄▄█  ▄▄▀ █ ▄█  █   ▄▄▀  ▄▄▀ █▄▄█ █▄▄  █▄▄  ▀  █ ▀▄▄▀ ▀▄▄█ "
echo " ▄▄▄▀  █  ▀▄▄▀  ▀█▀ █▀▀█ █  █  ▄▄▀ █▄▄▄ ▀█▄▀ ▄█▄ █▄▄▄ ▄▄▄▀    █ ▄▄▄▀ ▀▄▄▀    █ ▀▄▄▀  ▄▄▀ "
)
