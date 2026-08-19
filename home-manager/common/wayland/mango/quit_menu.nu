def may-exit [] {
  mmsg get all-clients
  | from json
  | get clients
  | if ($in | is-not-empty) {
    notify-send "There are still open clients!"
    exit
  }
}

def quit [] {
  may-exit
  mmsg dispatch quit | ignore
  systemctl --user stop mango-session.target
}

[ ' poweroff' ' hibernate' '󰈆 quit' '󰍃 logout' '󰜉 reboot' ]
  | to text
  | bemenu --width-factor 0.06
  | match ($in | split words -l 4 | first) {
    'quit' => { quit }
    'poweroff' => { quit; poweroff }
    'logout' => { quit; loginctl terminate-user $env.USER }
    'hibernate' => { systemctl hibernate }
    'reboot' => { quit; reboot }
    _ => ()
  }

