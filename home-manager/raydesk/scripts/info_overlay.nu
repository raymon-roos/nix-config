def temps [] {
  sys temp | get temp | sort -r | first | $"  ($in) ℃ "
}

( notify-send
  --transient
  --app-name window_manager
  --category info_overlay
  --replace-id (makoctl list -j | from json | get 0?.id | default "0")
  -- (date now | format date " %a %h %d\n %T") (temps)
)
