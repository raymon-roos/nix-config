def temps [] {
  sys temp | get temp | sort -r | first | $"  ($in) ℃ "
}

( notify-send --app-name window_manager --category info_overlay
  (date now | format date " %a %h %d\n %T")
  (temps)
)
