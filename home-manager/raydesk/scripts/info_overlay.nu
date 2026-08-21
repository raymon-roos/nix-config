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

( notify-send --app-name window_manager --category info_overlay
  (date now | format date " %a %h %d\n %T")
  (temps)
)
