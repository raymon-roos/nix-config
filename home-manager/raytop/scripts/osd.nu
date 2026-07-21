def main [] { }

def "main brightness" [--set: string] {
  brightnessctl set $'($set)' --min-value 10

  brightnessctl info
    | parse -r '(?<percent>\d+)%'
    | get percent.0
    | into int
    | progress-bar 
    | notify $'🔆 ($in)'
}

def "main sound set" [val: string --mic=false] {
  let target = if $mic { '@DEFAULT_SOURCE@' } else '@DEFAULT_SINK@' 

  wpctl set-volume $target $'($val)' --limit 1.0

  let state = parse-wpctl --mic=$mic
  $state.vol
    | progress-bar
    | notify $"($state.symbol) ($in)"
}

def "main sound mute" [--mic=false] {
  let target = if $mic { '@DEFAULT_SOURCE@' } else '@DEFAULT_SINK@' 

  wpctl set-mute $target toggle

  let state = parse-wpctl --mic=$mic
  $state.vol
    | progress-bar
    | notify $"($state.symbol) ($in)"
}

def parse-wpctl [--mic=false]: nothing -> record {
  let target = if $mic { '@DEFAULT_SOURCE@' } else '@DEFAULT_SINK@'

  wpctl get-volume $target
    | parse -r 'Volume: (?<vol>\<[\d\.]+\>) ?(?:\[(?<muted>\w+)\])?'
    | first
    | update vol { ($in | into float) * 100 | math round }
    | update muted { if $in == 'MUTED' { true } else false }
    | insert symbol { match [$in.muted $mic] {
        [false false] => '󰜟 '
        [false true] => ' '
        [true false] => '󰓄 '
        [true true] => '󰍭 '
      } }
}

def progress-bar []: int -> string {
  match ($in) {
    #       0123456789   × 10%
    0 =>   '',
    100 => '',
    $x => {
      let y = $x // 10 - 1
      ("" +
        ("" | fill -a l -c "" -w $y) +
        ("" | fill -a l -c "" -w (8 - $y))
        + "")
    }
  }
}

def notify [msg: string] {
  notify-send --app-name window_manager --category osd $'($msg)'
}
