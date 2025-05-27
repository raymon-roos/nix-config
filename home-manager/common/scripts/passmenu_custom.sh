# Script to copy secrets from pass https://www.passwordstore.org/ using bemenu
# pass files are expected to have the following structure:
#
# P$ssw0rd
# username: johnny
# email: john@domain.com

set -o errexit
set -o pipefail

password_dir="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
clip_time="${PASSWORD_STORE_CLIP_TIME:-45}"
field_delimiter="${PASSWORD_STORE_FIELD_DELIMITER:-: }"

password_file="$(
    fd --base-directory="$password_dir" -e gpg '.' -X printf '%s\n' '{.}' | bemenu
)"

[[ -n $password_file ]] || exit

secret="$(pass ls "$password_file")"

if [[ "$(wc -l <<<"$secret")" == 1 ]]; then
    exec pass -c "$password_file"
fi

field_name="$(
    cat <<EOF | bemenu
password
$(awk -F "$field_delimiter" 'NR > 1 { print $1 }' <<<"$secret")
cancel
EOF
)"

case "$field_name" in
'cancel' | '') exit 0 ;;
'password') secret="$(head -n1 <<<"$secret")" ;;
*)
    secret="$(
        awk -F "$field_delimiter" -v field="$field_name" \
            'BEGIN {IGNORECASE = 1} NR > 1 { if ($1 == field) { print $2 } }' <<<"$secret"
    )"
    ;;
esac

[[ -n $secret ]] || exit

sleep_process_title='passmenu sleep'
pkill -x "$sleep_process_title" 2>/dev/null && sleep 0.5
printf '%s' "$secret" | wl-clip -selection 'clipboard' -loops 2 &&
    (
        (exec -a "$sleep_process_title" bash <<<"trap 'kill %1' TERM; sleep '$clip_time' & wait")
        wl-clip -selection 'clipboard' </dev/null
    ) >/dev/null 2>&1 &
disown
