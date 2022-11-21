#!/usr/bin/env bash
trap 'echo -e "\e[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\e[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. ../terminal.sh
. ../buffer.sh
. font_line.sh
popd >/dev/null || true


on_terminal_write() {
  buffer write "$@"
}

buffer clear

font_line_print 2 1 "" "AaBbCcDdEeFfGg"  >/dev/null
font_line_print 2 7 "" "HhIiJjKkLlMmNn"  >/dev/null
font_line_print 2 13 "" "OoPpQqRrSsTtUu"  >/dev/null
font_line_print 2 19 "" "VvWwXxYyZz,.:!'\"?"  >/dev/null
font_line_print 2 25 "" "1234567890+-=/;*"  >/dev/null
font_line_print 2 31 "" "ÉéÈèÊêËëÏïÎîÇç_"  >/dev/null
font_line_print 2 37 "" "[]()ÀàÂâùûü<>{}"  >/dev/null

# Prints all letters
diff <(buffer save) <(
echo "                                                                                                               "
echo "  ┏━━━━┓          ┓━━━┓   ┓       ┏━━━━┓          ┓━━━━┓       ┏  ┏━━━━           ┏━━━━   ┏━━┓  ┏━━━━┓         "
echo "  ┃    ┃   ━━━━┓  ┃━━━┛┓  ┃━━━━┓  ┃       ┏━━━━┓  ┃    ┃  ┏━━━━┃  ┃       ┏━━━━┓  ┃       ┃     ┃       ┏━━━━┓ "
echo "  ┃━━━━┃  ┏━━━━┃  ┃    ┃  ┃    ┃  ┃       ┃       ┃    ┃  ┃    ┃  ┃━━━    ┃━━━━┛  ┃━━━   ━┃━━   ┃  ━━┓  ┃    ┃ "
echo "  ╹    ╹  ┗━━━━┗  ┛━━━━┛  ┛━━━━┛  ┗━━━━┛  ┗━━━━┛  ┛━━━━┛  ┗━━━━┗  ┗━━━━   ┗━━━━   ╹       ┃     ┗━━━━┛  ┗━━━━┃ "
echo "                                                                                          ┛              ━━━━┛ "
echo "                                                                                                      "
echo "  ╻    ╻  ┓       ━┓━  ▪      ━┓     ▪  ╻    ┏  ┓       ┓       ┓   ┏━━┓━━┓           ┏━┓   ╻         "
echo "  ┃    ┃  ┃━━━━┓   ┃   ┓       ┃     ┓  ┃  ┏━┛  ┃  ┏━━  ┃       ┃   ┃  ┃  ┃  ┓━━┓━━┓  ┃ ┗┓  ┃  ┓━━━━┓ "
echo "  ┃━━━━┃  ┃    ┃   ┃   ┃       ┃     ┃  ┃━━┛━┓  ┃━━┛━┓  ┃       ┃   ┃     ┃  ┃  ┃  ┃  ┃  ┗┓ ┃  ┃    ┃ "
echo "  ╹    ╹  ┛    ┗  ━┗━  ┗  ┗━━━━┛     ┃  ╹    ┗  ┛    ┗  ┗━━━━┛  ┗━  ╹     ╹  ┛     ┗  ╹   ┗━┛  ┛    ┗ "
echo "                                  ┗━━┛                                                                "
echo "                                                                                                             "
echo "  ┏━━━━┓          ┏━━━━┓          ┏━━━━┓          ┏━━━━┓          ┏━━━━┓          ━━┏━━   ┏   ╻    ╻         "
echo "  ┃    ┃  ┏━━━━┓  ┃    ┃  ┏━━━━┓  ┃    ┃  ┏━━━━┓  ┃    ┃  ┏━━━━┓  ┗━━━━┓  ┏━━━━┓    ┃    ━┃━  ┃    ┃  ┏    ┓ "
echo "  ┃    ┃  ┃    ┃  ┃━━━━┛  ┃    ┃  ┃  ━┓┃  ┃    ┃  ┃━━━┓┛  ┃            ┃  ┗━━━━┓    ┃     ┃   ┃    ┃  ┃    ┃ "
echo "  ┗━━━━┛  ┗━━━━┛  ╹       ┃━━━━┛  ┗━━━┗━  ┗━━━━┃  ╹   ┗━  ┛       ┗━━━━┛  ┗━━━━┛    ┗     ┗━  ┗━━━━┗  ┗━━━━┗ "
echo "                          ┛                    ┗                                                             "
echo "                                                                                                                 "
echo "  ╻    ╻          ╻     ╻           ━┓  ┏━          ╻    ╻          ╺━━━━┓                      ╻   ┛   ╹╹  ┏━┓  "
echo "  ┃    ┃  ┏    ┓  ┃     ┃  ┏     ┓   ┃  ┃   ━┓  ┏━  ┃    ┃  ┏    ┓  ┏━━━━┛  ╺━━━━┓          ▪   ┃             ┃  "
echo "  ┗┓  ┏┛  ┗┓  ┏┛  ┃  ┃  ┃  ┃  ┃  ┃   ┗━━┓    ┗━━┓   ┗━━┏━┛  ┃    ┃  ┃       ┏━━━━┛          ▪   ┃            ┏┛  "
echo "   ┗━━┛    ┗━━┛   ┗━━┗━━┛  ┗━━┗━━┛  ━┛  ┗━  ━┛  ┗━     ┛    ┗━━━━┃  ┗━━━━╸  ┗━━━━╸  ┛   ▪       ▪            ▪   "
echo "                                                             ━━━━┛                                               "
echo "                                                                                                                   "
echo "  ━┓   ┏━━━━┓  ┏━━━━┓  ╻    ╻  ┏━━━━╸  ┏━━━━╸  ┏━━━━┓  ┏━━━━┓  ┏━━━━┓  ┏━━━┏┓                         ╻            "
echo "   ┃        ┃       ┃  ┃    ┃  ┗━━━━┓  ┃━━━━┓  ┃    ┃  ┃━━━━┃  ┃    ┃  ┃  ┏┛┃    ╻            ▁▁▁    ┏┛  ▪   ╺┓╻┏╸ "
echo "   ┃   ┏━━━━┛    ━━━┃  ┗━━━━┃       ┃  ┃    ┃       ┃  ┃    ┃  ┗━━━━┃  ┃ ┏┛ ┃  ╺━╋━╸  ╺━━━╸   ━━━   ┏┛       ╺━╋━╸ "
echo "  ━┗━  ┗━━━━╸  ┗━━━━┛       ╹  ┗━━━━┛  ┗━━━━┛       ╹  ┗━━━━┛       ╹  ┗━┛━━┛    ╹                  ╹    ┛   ╺┛╹┗╸ "
echo "                                                                                                                   "
echo "    ┏━╸            ╺━┓             ┏━━┓            ▪ ▪            ▪ ▪     ┏━┓                            "
echo "  ┏━━━━     ┏━╸   ┏━━━━    ╺━┓    ┏━━━━    ┏━━┓   ┏━━━━    ▪ ▪    ━┓━ ▪ ▪ ━┓━ ┏━┓ ┏━━━━┓                 "
echo "  ┃       ┏━━━━┓  ┃       ┏━━━━┓  ┃       ┏━━━━┓  ┃       ┏━━━━┓   ┃   ┓   ┃   ┓  ┃       ┏━━━━┓         "
echo "  ┃━━━    ┃━━━━┛  ┃━━━    ┃━━━━┛  ┃━━━    ┃━━━━┛  ┃━━━    ┃━━━━┛   ┃   ┃   ┃   ┃  ┃       ┃              "
echo "  ┗━━━━   ┗━━━━   ┗━━━━   ┗━━━━   ┗━━━━   ┗━━━━   ┗━━━━   ┗━━━━   ━┗━  ┗  ━┗━  ┗  ┗━━━━┛  ┗━━━━┛         "
echo "                                                                                    ━┛      ━┛    ╺━━━━╸ "
echo "  ┏━━  ━━┓   ┏━  ━┓    ╺━┓             ┏━━┓                                                  ┏━  ━┓  "
echo "  ┃      ┃  ┏┛    ┗┓  ┏━━━━┓   ╺━┓    ┏━━━━┓   ┏━━┓    ╺━┓     ┏━━┓    ▪ ▪      ┏━┛  ┗━┓     ┃    ┃  "
echo "  ┃      ┃  ┃      ┃  ┃    ┃   ━━━━┓  ┃    ┃   ━━━━┓  ┏    ┓  ┏    ┓  ┏    ┓  ┏━┛      ┗━┓  ┏┛    ┗┓ "
echo "  ┃      ┃  ┃      ┃  ┃━━━━┃  ┏━━━━┃  ┃━━━━┃  ┏━━━━┃  ┃    ┃  ┃    ┃  ┃    ┃  ┗━┓      ┏━┛  ┗┓    ┏┛ "
echo "  ┃      ┃  ┗┓    ┏┛  ╹    ╹  ┗━━━━┗  ╹    ╹  ┗━━━━┗  ┗━━━━┗  ┗━━━━┗  ┗━━━━┗    ┗━┓  ┏━┛     ┃    ┃  "
echo "  ┗━━  ━━┛   ┗━  ━┛                                                                          ┗━  ━┛  "
)
