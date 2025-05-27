# Companion script for cmus: https://cmus.github.io/
# Runs in a loop, and prints plain text lyrics for currenly playing song from
# genius.com to stdout

set -o errexit
set -o nounset
set -o pipefail

tags="$(cmus-remote -Q)"

artist="$(awk -F 'tag artist ' '/artist/ {printf $2}' <<<"$tags")"
artist=${artist:-"$(awk -F 'tag albumartist ' '/albumartist/ {printf $2}' <<<"$tags")"}
title="$(awk -F 'tag title ' '/title/ {printf $2}' <<<"$tags")"
genre="$(awk -F 'tag genre  ' '/genre/ {printf tolower($2)}' <<<"$tags")"

if [[ -z $artist ]]; then
    printf '%s\n' 'warning: missing [artist]. Is the tag correctly set?'
fi

if [[ -z $title ]]; then
    printf '%s\n' 'error: missing [title]. Is the tag correctly set?'
    exit 0
fi

playing="$(awk -F 'status ' '/status/ {printf $2}' <<<"$tags")"
continue="$(awk -F 'set continue ' '/continue/ {print $2}' <<<"$tags")"

duration="$(awk -F 'duration ' '/duration/ {print $2}' <<<"$tags")"
position="$(awk -F 'position ' '/position/ {print $2}' <<<"$tags")"
remaining=$((duration - position + 3))

printf '\n%s\n\n' "$artist - $title"

if [[ "$genre" =~ instrumental|ambient ]]; then
    printf '%s\n' 'instrumental track'
    sleep "${remaining}s"
    exec "$0"
fi

lyric_file="$HOME/files/music/lyrics/${artist//\//_} - ${title//\//_}.txt"

if [[ -f "$lyric_file" && -r "$lyric_file" ]]; then
    cat "$lyric_file"
else
    printf '%s\n' 'no local lyric file found - dowloading from genius.com'

    lyrics="$(lyrical-rs --artist "$artist" --title "$title")"
    printf '%s\n' "$lyrics" | tee "$lyric_file"
fi

if [[ "$playing" == "playing" && "$continue" == "true" ]]; then
    sleep "${remaining}s"
    exec "$0"
fi
