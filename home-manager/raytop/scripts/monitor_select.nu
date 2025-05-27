# Bemenu, and some other dmenu-inspired wayland menus, allow returning a value
# not in list by submitting the input with shift+enter

mut config = {}

let monitors = ^hyprctl monitors -j
    | from json 

$config.name = $monitors
    | where name != eDP1 # eDP1 is the integrated laptop screen
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

$config.position = [auto-left auto-right auto-up auto-down] 
    | to text 
    | bemenu -p 'position'

$config.scale = echo auto | bemenu -p 'scale'

let mirror = $monitors
    | get name 
    | prepend 'no' 
    | to text
    | bemenu -p 'mirror?' 
if ($mirror) != 'no' {
    $config.mirror = $'mirror, ($mirror)'
}

$config | values | str join ', ' | ^hyprctl keyword 'monitor' $in
