# Script to copy secrets from pass https://www.passwordstore.org/ using bemenu
# pass files are expected to have the following structure:
#
# P$ssw0rd
# username: johnny
# email: john@domain.com

let pass_dir = $env.PASSWORD_STORE_DIR? 
    | default $'($env.HOME)/.password-store'

let field_delimiter = $env.PASSWORD_STORE_FIELD_DELIMITER?
    | default ':'

let old_clipboard = wl-clip -out -selection clipboard
    | complete 
    | get stdout

let secret = choose_pass | read_pass
let field = $secret | choose_field

$secret 
    | divulge $field
    # | to_clipboard 
    | if ($in | is-empty) {
        print -e 'Error: no such field in password file'
    } else print -n $in


def choose_pass [] {
    fd --base-directory $pass_dir -e gpg '.' -X printf '%s\n' '{.}' 
        | bemenu 
}

def choose_field [] {
    get field | to text | bemenu --accept-single
}

def read_pass [] {
    let secret = pass ls $in | lines
    $secret 
        | parse '{field}: {val}' 
        | prepend {'field': 'password', 'val': $secret.0?}
}

def divulge [field: string] {
    find $field 
        | get val.0?
        | if ($in | is-empty) {
            print -e 'Error: no such field in password file'
        } else echo $in
        | default ''
}

def to_clipboard [] {
    if ($in | is-not-empty) {
        wl-clip -i -selection clipboard -loops 1
        wipe_clipboard 
    }
}

def wipe_clipboard [] {
    sleep ($env.PASSWORD_STORE_CLIP_TIME?
        | default 45
        | into duration -u sec)

    $old_clipboard | wl-clip -selection clipboard
}
