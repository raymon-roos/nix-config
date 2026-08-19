def battery [] {
  let icons = {
    charging:    [ '󰢟 ' '󰢜 ' '󰂆 ' '󰂇 ' '󰂈 ' '󰢝 ' '󰂉 ' '󰢞 ' '󰂊 ' '󰂋 ' '󰂅 ']
    discharging: [ '󱃍 ' '󰁺'  '󰁻'  '󰁼'  '󰁽'  '󰁾 ' '󰁿'  '󰂀'  '󰂁'  '󰂂'  '󰁹' ]
  }
  let bat = acpi -b
    | parse -r '\w+ \d?: (?<charging>(?:Dis|Not )?[Cc]harging), (?<percent>\d+)%(?:, (?<hr>\d\d):(?<min>\d\d):(?<sec>\d\d) (?:remaining|until charged))?'
    | first

  $icons
    | if $bat.charging == 'Discharging' {
      get discharging
    } else {
      get charging
    }
    | get (($bat.percent | into int) // 10)
    | $"($in)($bat.percent)%(if $bat.charging != 'Not charging' { $bat | format pattern '({hr}:{min})' })"
}

( notify-send --app-name window_manager --category info_overlay
  (date now | format date " %a %h %d\n %T")
  (battery)
)
