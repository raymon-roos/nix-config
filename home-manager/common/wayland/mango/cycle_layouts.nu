# Two separate layout cycles with one keybind, one for landscape mode, one for portrait mode
let monitor = mmsg get all-monitors
  | from json
  | get monitors
  | where active
  | first
  | select layout_symbol width height

{T: scroller S: fair F: tile , VT: vertical_scroller VS: vertical_fair VF: vertical_tile}
  | get -o $monitor.layout_symbol
  | default (if ($monitor.width > $monitor.height) { 'tile' } else { 'vertical_tile' })
  | tee {notify-send --app-name window_manager $in}
  | mmsg dispatch $'setlayout,($in)'
  | ignore

