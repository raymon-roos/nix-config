# Register ssh key with a singleton instance of ssh-agent, using `keychain`
def --env sshagent [keyfile: string = id_ed25519] {
  keychain --dir $"($env.XDG_STATE_HOME)/keychain" --eval $keyfile
    | parse '{var}={val};{_}' 
    | each {str trim --char '"'}
    | transpose -rd
    | load-env
}

def --env nixrc [] {
    if ($env.PWD != $"($env.XDG_CONFIG_HOME)/nix") {
        cd $"($env.XDG_CONFIG_HOME)/nix"
    }
    nvim flake.nix
}

def nhs [query: string] {
   nh search $query -j
      | from json
      | get results
      | rename --block {|c| str replace 'package_' '' }
      | (sk --preview-window 'right:60%' -0
        -f { $in.attr_name }
        -p { select attr_name pversion homepage programs description | table -e})
      | default []
      | select -o attr_name pversion homepage
}

def --env vimrc [] {
    if ($env.PWD != $"($env.XDG_CONFIG_HOME)/nvim") {
        cd $"($env.XDG_CONFIG_HOME)/nvim"
    }
    nvim init.lua
}

def --env calrc [] {
    if ($env.PWD != $"($env.XDG_FILES_HOME_DIR)/calendar") {
        cd $"($env.XDG_FILES_HOME_DIR)/calendar"
    }
    nvim -o school.rem personal.rem
}

def --env rem [] {
    ^cal -m3
    remind -qgaad $"($env.XDG_FILES_HOME_DIR)/calendar"
}

def --env remc [] {
    remind -mcu12b1@2,2,1wtt $"($env.XDG_FILES_HOME_DIR)/calendar" | less --raw
}

def --env zettel [] {
    if ($env.PWD != $env.XDG_NOTES_HOME_DIR) {
        cd $env.XDG_NOTES_HOME_DIR
    }
    nvim index-202202270044.md
}
