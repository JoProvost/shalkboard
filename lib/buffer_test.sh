#!/usr/bin/env bash
trap 'echo -e "\e[31mFailure at $0:$LINENO"; tail -n +$((LINENO-1)) $0 | sed "/^$/q;s/^/| /g" | sed "/^$/d"; echo -e "\e[0m"; exit 1' ERR

pushd "$(dirname -- "$0")" >/dev/null || exit 1
. buffer.sh
popd >/dev/null || true


buffer clear
buffer write 1 1 'first line'

# buffer write keeps text on a newly created line
diff <(buffer save) <(
echo 'first line'
)


buffer clear
buffer write 1 1 'first line'
buffer write 1 1 'FIRST'

# buffer write replaces the text at the beginning of an existing line
diff <(buffer save) <(
echo 'FIRST line'
)


buffer clear
buffer write 1 1 'first line'
buffer write 7 1 'LINE'

# buffer write replaces the text at the end of an existing line
diff <(buffer save) <(
echo 'first LINE'
)


buffer clear
buffer write 1 1 'first line'
buffer write 13 1 'EXTENDED'

# buffer write appends the text at the end of an existing line
diff <(buffer save) <(
echo 'first line  EXTENDED'
)


buffer clear
buffer write 1 1 'first line'
buffer write 1 3 'third line'
buffer write 1 5 'fifth line'

# buffer write creates lines as needed
diff <(buffer save) <(
echo 'first line'
echo ''
echo 'third line'
echo ''
echo 'fifth line'
)


buffer write 1 1 'rst line'
buffer write 1 2 'second line'
buffer write 1 3 'ird line'
buffer clear

# buffer clear removes all lines
diff <(buffer save) <(
echo ''
)



buffer write 1 1 'abcdef'
buffer write 1 2 'ghijkl'
buffer write 1 4 'uvwx'

# buffer copy extracts everything
diff <(buffer copy 1 1 6 4) <(
echo 'abcdef'
echo 'ghijkl'
echo
echo 'uvwx'
)


buffer write 1 1 'abcdef'
buffer write 1 2 'ghijkl'
buffer write 1 3 'mnopqr'
buffer write 1 4 'stuvwx'

# buffer copy extracts everything between start and end coordinates
diff <(buffer copy 2 2 5 3) <(
echo 'hijk'
echo 'nopq'
)


buffer write 1 1 'abcdef'
buffer write 1 2 'ghijkl'
buffer write 1 3 'mnopqr'
buffer write 1 4 'stuvwx'

# buffer copy extracts blanks at right of the printed area
diff <(buffer copy 7 2 8 3) <(
echo ''
echo ''
)


buffer write 1 1 'abcdef'
buffer write 1 2 'ghijkl'
buffer write 1 3 'mnopqr'
buffer write 1 4 'stuvwx'

# buffer copy extracts blanks at under the printed area
diff <(buffer copy 1 5 6 6) <(
echo ''
echo ''
)

