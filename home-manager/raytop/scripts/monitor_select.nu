# Bemenu, and some other dmenu-inspired wayland menus, allow returning a value
# not in list by submitting the input with shift+enter

mut config = {
    # Declare object keys to fix ordering
    name: null,
    mode: null,
    position: auto-right,
    scale: 1,
    mirror: null,
}

let monitors = ^hyprctl monitors all -j
    | from json 

$config.name = $monitors
    | where name != eDP-1 # eDP1 is the integrated laptop screen
    | select name make model 
    | each {values | str join ', '}
    | to text
    | bemenu -p 'monitor'
    | parse '{name}, {_}'
    | get 0.name

$config.mode = $monitors
    | where name == $config.name
    | get availableModes 
    | to text 
    | bemenu -p mode
    | default 'preferred'

[auto-left auto-right auto-up auto-down] ++ (
    $monitors 
        | where name != $config.name
        | get name
        | each {$'mirror, ($in)'}
    )
    | to text 
    | bemenu -p 'position'
    | if ($in =~ 'mirror') {
        $config.mirror = $in
        $config.position = 'auto'
    } else {
        $config.position = $in | default 'auto'
    }

$config.scale = echo '1' | bemenu -p 'scale' | default 1

# `hyprctl keyword` allows changing a specific config at runtime.
# hyprland monitor config: <name, resolution, position, scale> [, mirror <name>, ...]
$config | values | filter {is-not-empty} | str join ', ' | tee { print} | ^hyprctl keyword 'monitor' $in

# split workspaces hyprland plugin function: try to rescue windows from oter monitors
hyprctl dispatch 'split:grabroguewindows'
