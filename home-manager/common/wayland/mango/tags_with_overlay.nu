# Switch/toggle tags with transient overlay showing state of tags
const symbols = {
  active: {
    none: {1: '󰎤 ' 2: '󰎧 ' 3: '󰎪 ' 4: '󰎭 ' 5: '󰎱 ' 6: '󰎳 ' 7: '󰎶 ' 8: '󰎹 ' 9: '󰎼 '}
    some: {1: '󰼏 ' 2: '󰼐 ' 3: '󰼑 ' 4: '󰼒 ' 5: '󰼓 ' 6: '󰼔 ' 7: '󰼕 ' 8: '󰼖 ' 9: '󰼗 '}
  }
  inactive: {
    none: {1: '󰎦 ' 2: '󰎩 ' 3: '󰎬 ' 4: '󰎮 ' 5: '󰎰 ' 6: '󰎵 ' 7: '󰎸 ' 8: '󰎻 ' 9: '󰎾 '}
    some: {1: '󰎥 ' 2: '󰎨 ' 3: '󰎫 ' 4: '󰎲 ' 5: '󰎯 ' 6: '󰎴 ' 7: '󰎷 ' 8: '󰎺 ' 9: '󰎽 '}
  }
}

def main [--action: string, --tag: int] {
  if $action not-in ["view" "toggleview" "tagsilent" "toggletag"] or ($tag < 0 or $tag > 9) {
    return
  }

  mmsg dispatch $"($action),($tag)" | ignore

  mmsg get all-monitors
    | from json
    | get monitors
    | where active == true
    | get 0.tags
    | each {|t|
      if $t.is_active { $symbols.active } else { $symbols.inactive }
        | if $t.client_count > 0 { get some } else { get none }
        | get $"($t.index)"
    }
    | str join
    | ( notify-send
        --transient
        --app-name window_manager
        --category tags_overlay 
        --replace-id (makoctl list -j | from json | get 0?.id | default "0")
        -- $in
      )
}

