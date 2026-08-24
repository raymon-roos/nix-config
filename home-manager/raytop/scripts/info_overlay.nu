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

def temps [] {
  sys temp
    | get temp
    | math round -p 1
    | wrap temp
    | enumerate 
    | join --right (['' '' '󰋊']
    | wrap name
    | enumerate) index
    | flatten
    | reject index
    | format pattern '{name}{temp}'
    | str join ' '
}

( notify-send
  --transient
  --app-name window_manager
  --category info_overlay
  --replace-id (makoctl list -j | from json | get 0?.id | default "0")
  -- (date now | format date " %a %h %d\n %T") $"(battery)\n(temps)"
)
