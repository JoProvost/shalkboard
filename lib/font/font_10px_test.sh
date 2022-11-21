#!/usr/bin/env bash
trap 'echo -e "\e[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\e[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. ../terminal.sh
. ../buffer.sh
. font_10px.sh
popd >/dev/null || true


on_terminal_write() {
  buffer write "$@"
}

buffer clear

font_10px_print 2 1 ""  "ABCDEFGabcdefg" >/dev/null
font_10px_print 2 6 ""  "HIJKLMNhijklmn"  >/dev/null
font_10px_print 2 11 "" "OPQRSTUopqrstu"  >/dev/null
font_10px_print 2 16 "" "VWXYZ_!vwxyz\"#"  >/dev/null
font_10px_print 2 21 "" "\$%&'()*+,-.<=>"  >/dev/null
font_10px_print 2 26 "" "0123456789:;?@"  >/dev/null
font_10px_print 2 31 "" "[\\/] "  >/dev/null

# Prints all letters
diff <(buffer save) <(
echo "   ▄█▀█▄  █▀▀▀▀█▄ ▄█▀▀▀█▄ █▀▀▀▀█▄ █▀▀▀▀▀█ █▀▀▀▀▀█ ▄█▀▀▀█▄    ▄     ▄▄▄▄     ▄▄▄    ▄▄▄▄    ▄▄▄▄▄   ▄▄▄▄▄    ▄▄▄  "
echo "  █▀▄█▄▀█ ▀█ ██ █ █ █▀█▄█ ▀█ ██ █ █ ███▀▀ █ ███▀▀ █ ███▄█  ▄▀ ▀▄    █  █   █   ▀    █  █   █       █       █   ▀ "
echo "  █ ▄▄▄ █  █ ▄▄▀█ █ █ ▄▄▄  █ ██ █ █ ▄▄█   █ ▄▄█   █ ██▀▀█  █▀▀▀█    █▀▀▄   █        █  █   █▀▀     █▀▀     █  ▄▄ "
echo "  █ █ █ █ █▀ ▀▀▄█ █▄▀▀▀▄█ █▀ ▀▀▄█ █ ▀▀▀▀█ █ █     █▄▀▀▀ █  █   █   ▄█▄▄▀   ▀▄▄▄▀   ▄█▄▄▀   █▄▄▄▄   █       ▀▄▄▄█ "
echo "  ▀▀▀ ▀▀▀ ▀▀▀▀▀▀   ▀▀▀▀▀  ▀▀▀▀▀▀  ▀▀▀▀▀▀▀ ▀▀▀      ▀▀▀▀▀▀                                                        "
echo "  █▀█ █▀█  █▀▀▀█      █▀█ █▀█▄█▀█ █▀█     █▀█▄█▀█ █▀█▄█▀█  ▄   ▄    ▄▄▄        ▄   ▄   ▄   ▄       ▄   ▄   ▄   ▄ "
echo "  █ █▄█ █  ▀█ █▀      █ █ █ █▀▄█▀ █ █     █ ▄▀▄ █ █ ▄▀█ █  █   █     █         █   █ ▄▀    █       █▀▄▀█   █▀▄ █ "
echo "  █ ▄▄▄ █   █ █   ▄▄▄ █ █ █ ▄▀█▄  █ █     █ █▄█ █ █ ██▄ █  █▀▀▀█     █         █   █▀▄     █       █ ▀ █   █  ▀█ "
echo "  █ █ █ █  █▀ ▀█  █▄▀▀▀▄█ █ ██▄▀█ █ ▀▀▀▀█ █ █ █ █ █ █ █ █  █   █    ▄█▄    ▀▄▄▄▀   █  ▀▄   █▄▄▄▄   █   █   █   █ "
echo "  ▀▀▀ ▀▀▀  ▀▀▀▀▀   ▀▀▀▀▀  ▀▀▀ ▀▀▀ ▀▀▀▀▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀                                                        "
echo "  ▄█▀▀▀█▄ █▀▀▀▀█▄ ▄█▀▀▀█▄ █▀▀▀▀█▄ ▄█▀▀▀█▄ █▀▀▀▀▀█ █▀█ █▀█   ▄▄▄    ▄▄▄▄     ▄▄▄    ▄▄▄▄     ▄▄▄    ▄▄▄▄▄   ▄   ▄ "
echo "  █ ███ █ █ ███ █ █ ███ █ █ ███ █ █ ███▄█ ▀▀█ █▀▀ █ █ █ █  █   █   █   █   █   █   █   █   █   ▀     █     █   █ "
echo "  █ ███ █ █ ▄▄▄█▀ █ █▀█ █ █ ▄ ▄█▀ ██▄▄▄▀█   █ █   █ █ █ █  █   █   █▀▀▀    █ ▄ █   █▀█▀     ▀▀▀▄     █     █   █ "
echo "  █▄▀▀▀▄█ █ █     █▄▀▀▄▀█ █ ██▄▀█ █▄▀▀▀▄█   █ █   █▄▀▀▀▄█  ▀▄▄▄▀   █       ▀▄▄▀▄   █  ▀▄   ▀▄▄▄▀     █     ▀▄▄▄▀ "
echo "   ▀▀▀▀▀  ▀▀▀      ▀▀▀▀▀▀ ▀▀▀ ▀▀▀  ▀▀▀▀▀    ▀▀▀    ▀▀▀▀▀                                                         "
echo "  █▀█ █▀█ █▀█ █▀█ █▀█ █▀█ █▀█ █▀█ █▀▀▀▀▀█            ▄     ▄   ▄   ▄   ▄   ▄   ▄   ▄   ▄   ▄▄▄▄▄    ▄ ▄     ▄ ▄  "
echo "  █ █▄█ █ █ █ █ █ █▄▀█▀▄█ █▄▀█▀▄█ ▀▀██▀▄█            █     █   █   █   █   ▀▄ ▄▀   ▀▄ ▄▀      ▄▀    ▀ ▀    ▄█▄█▄ "
echo "  ▀█ █ █▀ █ █▀█ █ ▄█▀▄▀█▄  ▀█ █▀  ▄█▀▄█▀             █      █ █    █ ▄ █    ▄▀▄      █      ▄▀             ▄█▄█▄ "
echo "   ▀█ █▀  █ ▄█▄ █ █ █▀█ █   █ █   █ ▀▀▀▀█            ▄       █     █▀ ▀█   █   █     █     █▄▄▄▄            █ █  "
echo "    ▀▀▀   ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀   ▀▀▀   ▀▀▀▀▀▀▀  ▀▀▀▀▀                                                                 "
echo "     ▄     ▄▄  ▄    ▄       ▄▄       ▄       ▄       ▄                                         ▄            ▄    "
echo "   ▄▀▀▀▀   ▀▀ ▄▀   █ █      ██     ▄▀         ▀▄   ▀▄█▄▀     █                               ▄▀    ▄▄▄▄▄     ▀▄  "
echo "    ▀▀▀▄    ▄▀     ▄▀▄ ▄           █           █  ▀▀███▀▀  ▀▀█▀▀   ██      ▀▀▀▀▀            ▀▄     ▄▄▄▄▄      ▄▀ "
echo "   ▀▀█▀    █  ██   ▀▄▄▀▄            ▀▄       ▄▀    ▀ █ ▀     ▀     ▄▀              ██         ▀▄            ▄▀   "
echo "                                                                                                                 "
echo "    ▄▄▄      ▄      ▄▄▄     ▄▄▄       ▄    ▄▄▄▄▄    ▄▄▄    ▄▄▄▄▄    ▄▄▄     ▄▄▄             ▄▄      ▄▄      ▄▄▄  "
echo "   █  ▄█    ▀█     ▀   █   ▀   █    ▄▀█    █▄▄▄    █          ▄▀   █   █   █   █    ██      ▀▀     ▀  █    ▀   █ "
echo "   █▄▀ █     █     ▄▀▀▀     ▀▀▀▄   ▀▀▀█▀       █   █▀▀▀▄    ▄▀     ▄▀▀▀▄    ▀▀▀█    ▄▄      ██       █     ▄▀█ █ "
echo "   ▀▄▄▄▀    ▄█▄    █▄▄▄▄   ▀▄▄▄▀      █    ▀▄▄▄▀   ▀▄▄▄▀   █       ▀▄▄▄▀    ▄▄▄▀    ▀▀      ▄▀       ▄     ▀▄█▄▀ "
echo "                                                                                                                 "
echo "    ▄▄▄    ▄           ▄    ▄▄▄          "
echo "    █      ▀▄         ▄▀      █          "
echo "    █        ▀▄     ▄▀        █          "
echo "    █▄▄        █   █        ▄▄█          "
echo "                                         "
)
