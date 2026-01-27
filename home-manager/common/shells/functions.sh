psg() {
    ps -aux | rg --color=always -i "($1|USER.*PID %CPU)" | rg --color=always -vi 'rg'
}

sshagent() {
    eval "$(keychain --dir "$XDG_STATE_HOME/keychain" --eval id_ed25519)"
}

volset() {
    wpctl set-volume "${2:-@DEFAULT_SINK@}" "$1"
}

volget() {
    wpctl get-volume "${1:-@DEFAULT_SINK@}"
}
