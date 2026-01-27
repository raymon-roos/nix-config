#!/usr/bin/env bash

dir="$(
    cat <<EOF | bemenu -c -l 12
projects/personal
projects/open-ict
.xdg/config
files
files/finance/hledger
files/documents
files/downloads
files/zettelkasten
scratch
EOF
)"

if [[ -n "$dir" && -d "$HOME/$dir" ]]; then
    exec kitty -1 --hold --working-directory "$HOME/$dir" yazi
fi
