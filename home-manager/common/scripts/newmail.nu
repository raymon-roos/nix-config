# Synchronize given maildirs (default all) in parallel,
# notify on completion, and list unread mail
def main [...accounts: string] {
    $accounts
        | default -e {himalaya account list -o json | from json | get name} 
        | par-each {|account|
            if (ps -l | where ($it.name =~ 'mbsync') and ($it.command =~ $account) | is-empty) {
                mbsync --config $'($env.XDG_CONFIG_HOME)/isync/isyncrc' $account
            }

            list_unread_mail $account | tee { notify $account }
        }
        | flatten
}

# Send desktop notification, highlighting accounts/folders with new mail
# Allows choosing a folder with bemenu and opening it in aerc.
def notify [account: string] {
    let new_mail_dirs = $in
        | group-by folder 
        | items {|folder, mail| {folder: ($folder), count: ($mail | length) } }
        | sort-by --reverse count
     
    let mako_action = $new_mail_dirs
        | each {$'--action=($in.folder)=($in.folder)'}
        | flatten

    let notif_body = $new_mail_dirs 
        | format pattern '{folder} {count} ' 
        | default -e "No new mail"
        | to text 

    notify-send ...$mako_action $'📬($account)' ($notif_body)
        | if ($in | is-not-empty) { 
            kitty --detach --hold aerc $':cf -a ($account) ($in)' 
        }
}

# Format unread mail from all accounts as a table
def list_unread_mail [account: string] {
    himalaya folder list -a $account -o json 
        | from json 
        | get name
        | each {|folder| 
            himalaya envelope list -a $account -f $folder -o json not flag seen 
                | format_envelope_list $account $folder
        }
        | flatten 
}

# Format envelope records of given folder on given account
# to show important info space-efficiently
def format_envelope_list [account: string, folder: string] {
    let format_addr = { values | where { is-not-empty } | first }
    $in | from json
        | insert account $account
        | insert folder $folder
        | move account --first
        | move folder --after account
        | update flags {|row| [...$row.flags (if ($row.has_attachment) {'@'})] | str join ','}
        | reject has_attachment
        | update from $format_addr
        | update to $format_addr
        | update date {into datetime}
}
