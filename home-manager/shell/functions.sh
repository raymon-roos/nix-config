#!/usr/bin/env sh

function des() {
    # First argument should be an existing project name,
    # depends on dev environment conventions used at work
    # If no argument was given, use the current directory
    current_dir="$(basename "$PWD")"
    docker exec -it php-"${1:-$current_dir}" php artisan db
}

function dep() {
    # enter interactive shell for php container, using cwd as name
    current_dir="$(basename "$PWD")"
    docker exec -it php-"${1:-$current_dir}" bash
}

function dex() {
    # enter interactive shell for given container, using cwd as name
    current_dir="$(basename "$PWD")"
    docker exec -it "$1"-"${2:-$current_dir}" bash
}

function psg() {
    ps -aux | rg --color=always -i "($1|USER.*PID %CPU)" | rg --color=always -vi 'rg'
}

function sshagent() {
    eval "$(keychain --dir "$XDG_STATE_HOME/keychain" --eval id_ed25519)"
}

function volset() {
    pactl set-sink-volume "${2:-@DEFAULT_SINK@}" "$1"
}

function volget() {
    pactl get-sink-volume "${1:-@DEFAULT_SINK@}"
}
