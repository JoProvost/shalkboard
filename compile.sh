#!/usr/bin/env bash

source() {
  source_file="$1"
  touch "${output}.deps"
  if ! grep -Fxq "${source_file}" "${output}.deps"; then
    echo "${source_file}" >> "${output}.deps"
    # shellcheck disable=SC1090
    ( . "$source_file" )
    cat <<EOF >> "$output"
# compiled from '$source_file'
$(grep -v '^pushd' "$source_file" | grep -v '^source ' | grep -v '^popd' | grep -v '^#!\/bin\/bash')

EOF
  fi
}

output="${2-"bin/$(basename -s .sh "$1")"}"
mkdir -p "$(dirname "$output")"
rm -f "${output}.deps"
head -n1 "$1" > "$output"

# shellcheck disable=SC1090
source "$1"
rm -f "${output}.deps"

gzip "$output"

cat <<"EOF" >> "$output"
#!/usr/bin/env bash
eval "$(tail --lines=+4 "$0" | zcat)"
exit $?
EOF

cat "${output}.gz" >> "$output"
rm "${output}.gz"

chmod +x "$output"
