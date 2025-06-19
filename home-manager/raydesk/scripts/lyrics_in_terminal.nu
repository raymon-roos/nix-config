# Companion script for cmus: https://cmus.github.io/
# Runs in a loop, and prints plain text lyrics for currenly playing song from
# genius.com to stdout

let data = cmus-remote -Q
    | parse '{k} {v}'
    | transpose -rad

let tags = $data.tag
    | parse '{tag} {val}'
    | transpose -rd

let continue = $data.set
    | parse "continue {cont}"
    | first
    | get cont
    | into bool

let artist = $tags.artist? | default $tags.albumartist?

if ($artist | is-empty) {
    print -e 'WARNING: missing `artist`. Is the tag correctly set?'
}

if ($tags.title? | is-empty) {
    print -e 'ERROR: missing `title`. Is the tag correctly set?'
    next_song
}

if (no_lyrics ($tags.genre? | default "")) {
    print 'instrumental track'
    next_song
}

let name = [$artist $tags.title] | each { file_sanitize } | str join ' - '

print $"\n($name)\n\n"

let file = $"($env.XDG_MUSIC_DIR)/lyrics/($name).txt"

match ($file | path type) {
    'file' => (^cat $file),
    null => {
        print "No local lyric file found - downloading from genius.com\n"

        fetch_lyrics $artist --title $tags.title | tee { save $file } | print
    }
    _ => {
        print -e 'ERROR: Lyric file path already occupied. Stopping'
        return
    } 
}

next_song 

# Sleep for the remaining song duration, then re-execute the script
def next_song [] {
    if ($data.status == 'playing' and $continue) {
        let remaining = ($data.duration | into int) - ($data.position | into int) + 1
            | into duration --unit sec

        sleep $remaining
        exec $env.CURRENT_FILE
    }
}

# Based on the genre, the song might have no lyrics
def no_lyrics [genre: string] {
    ['instrumental' 'ambient' 'score' 'orchestral'] | any {|elem|
        $genre | str contains -i $elem
    }
}

# replace `*`, `?`, and `/` with `_` in input string,
# just to be a little safer when used in file paths
def file_sanitize [] {
    str replace  --regex --all  '[*?/]' '_' | str trim
}

# Call lyrical-rs with optional `--artist` flag, if given `$artist` is not empty
def --wrapped fetch_lyrics [artist?: string ...rest] {
    if ($artist | is-not-empty) {
        return (^lyrical-rs --artist $artist ...$rest)
    }
    ^lyrical-rs ...$rest
}
