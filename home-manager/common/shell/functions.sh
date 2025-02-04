#!/usr/bin/env sh

des() {
    # First argument should be an existing project name,
    # depends on dev environment conventions used at work
    # If no argument was given, use the current directory
    current_dir="$(basename "$PWD")"
    docker exec -it php-"${1:-$current_dir}" php artisan db
}

dep() {
    # enter interactive shell for php container, using cwd as name
    current_dir="$(basename "$PWD")"
    docker exec -it php-"${1:-$current_dir}" bash
}

dex() {
    # enter interactive shell for given container, using cwd as name
    current_dir="$(basename "$PWD")"
    docker exec -it "$1"-"${2:-$current_dir}" bash
}

psg() {
    ps -aux | rg --color=always -i "($1|USER.*PID %CPU)" | rg --color=always -vi 'rg'
}

sshagent() {
    eval "$(keychain --dir "$XDG_STATE_HOME/keychain" --eval id_ed25519)"
}

volset() {
    pactl set-sink-volume "${2:-@DEFAULT_SINK@}" "$1"
}

volget() {
    pactl get-sink-volume "${1:-@DEFAULT_SINK@}"
}

# TEMPORARY MEASURE for starting and stopping project specific MariaDB
# databases. I found some nix code that sets the required variables as part of
# a flake's shellHook, only this shellHook cannot propagate function definitions.
function startdb()
{
    # Used to start a mariadb server included in a Nix flake's devShell.
    # Requires enironment variables to be set by the flake's shellHook.
    mysqld --no-defaults \
        --datadir="$MYSQL_DATADIR" --pid-file="$MYSQL_PID_FILE" \
        --socket="$MYSQL_UNIX_PORT" 2> "$MYSQL_HOME"/mysql.log &
    MYSQL_PID=$!
}

function stopdb()
{
    # Used to stop a mariadb server included in a Nix flake's devShell.
    # Requires enironment variables to be set by the flake's shellHook.
    mariadb-admin -u root --socket="$MYSQL_UNIX_PORT" shutdown
    kill "$MYSQL_PID"
    wait "$MYSQL_PID"
    unset MYSQL_PID
}
