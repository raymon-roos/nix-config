let monitors = wlr-randr --json
  | from json
  | where name != 'eDP-1'
  | select name modes

let mon = $monitors
  | get name
  | if ($in | length) > 1 {
    to text | bemenu -p 'output:'
  } else { first }

let mode = $monitors
  | where name == $mon
  | get 0.modes
  | format pattern '{width}x{height}@{refresh} (pref: {preferred})'
  | prepend 'preferred'
  | to text
  | bemenu -p 'mode:'
  | if ($in == 'preferred') { } else {
    parse '{mode} (pref: {_})' | get 0.mode
  }

let pos = ['left-of' 'right-of' 'above' 'below']
  | to text
  | bemenu -p 'position:'
  | default 'left-of'

let scale = [1 2 0.5]
  | to text
  | bemenu -p 'scale:'
  | default '1'

let transform = ['normal' 90 180 270]
  | to text
  | bemenu -p 'transform:'
  | default 'normal'

( wlr-randr
  --output $mon
  --transform $transform
  $'--($pos)' 'eDP-1'
  ...(if $mode == 'preferred' { ['--preferred'] } else { ['--mode' $mode] })
  ...(if $scale != 1 { ['--scale' $scale] })
)
