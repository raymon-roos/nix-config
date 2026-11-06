const symbols = {
  active: {
    none: ['󰎤 ' '󰎧 ' '󰎪 ' '󰎭 ' '󰎱 ' '󰎳 ' '󰎶 ' '󰎹 ' '󰎼 ']
    some: ['󰼏 ' '󰼐 ' '󰼑 ' '󰼒 ' '󰼓 ' '󰼔 ' '󰼕 ' '󰼖 ' '󰼗 ']
  }
  inactive: {
    none: ['󰎦 ' '󰎩 ' '󰎬 ' '󰎮 ' '󰎰 ' '󰎵 ' '󰎸 ' '󰎻 ' '󰎾 ']
    some: ['󰎥 ' '󰎨 ' '󰎫 ' '󰎲 ' '󰎯 ' '󰎴 ' '󰎷 ' '󰎺 ' '󰎽 ']
  }
}

def main [] {
  mmsg watch all-monitors
    | from json --objects
    | get monitors
    | each { where $it.active | first }
    | generate {|monitor={}, prev={}| listener $monitor $prev }
    | where $it.type? != null
    | each {|e| match $e.type {
      'tags_ev' => ($e.data.tags | tag-overlay | notify --category tags_overlay)
      'layout_ev' => ($e.data.layout | notify)
      _ => ()
    } }
    | ignore
}

def listener [monitor={}, prev={}]: nothing -> record {
  $monitor 
    | select name tags layout_symbol
    | update tags { select index is_active client_count }
    | rename mon_name tags layout
    | wrap data
    | match [
      ($in.data.tags.is_active != $prev.data?.tags?.is_active?)
      ($prev.data?.tags?.is_active? != null)
      ($in.data.mon_name == $prev.data?.mon_name?)
      ($in.data.layout != $prev.data?.layout?)
      ($prev.data?.layout? != null)
    ] {
      [true, true, true, _, _] => {out: {type: 'tags_ev' ...$in} next: $in}
      [_, _, true, true, true] => {out: {type: 'layout_ev' ...$in} next: $in}
      _ => {out: null next: $in}
    }
}

def tag-overlay []: table -> string {
  each {|t|
    if $t.is_active { $symbols.active } else { $symbols.inactive }
      | if $t.client_count > 0 { get 'some' } else { get 'none' }
      | get ($t.index - 1)
  }
  | str join
}

def notify [--category=null: oneof<string,nothing>]: string -> nothing {
  ( notify-send
    --transient
    --app-name 'window_manager'
    ...(if $category != null { [--category $category] } else {[]})
    --replace-id ( makoctl list -j
      | from json
      | where $it.app_name == 'window_manager'
      | if ($category | is-not-empty) {
          where $it.category == $category
        } else {}
      | get 0?.id 
      | default "0"
    )
    -- $in
  ) | ignore
}
