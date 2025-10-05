# Register ssh key with a singleton instance of ssh-agent, using `keychain`
def --env sshagent [keyfile: string = id_ed25519] {
  keychain --dir $"($env.XDG_STATE_HOME)/keychain" --eval $keyfile
    | lines 
    | where not ($it | is-empty)
    | parse '{var}={val}; export {_};' 
    | select var val 
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
        | sk --format {$in.package_attr_name} --preview {table -e}
        | default []
        | get -o package_attr_name
}

def --env vimrc [] {
    if ($env.PWD != $"($env.XDG_CONFIG_HOME)/nvim") {
        cd $"($env.XDG_CONFIG_HOME)/nvim"
    }
    nvim init.lua
}

def --env calrc [] {
    if ($env.PWD != $"($env.FILES_HOME)/calendar") {
        cd $"($env.FILES_HOME)/calendar"
    }
    nvim calendar.rem
}

def --env rem [] {
    ^cal -m3
    remind -qgaad $"($env.FILES_HOME)/calendar"
}

def --env remc [] {
    remind -cu12b1@2,2,1wtt $"($env.FILES_HOME)/calendar" | less --raw
}

def --env zettel [] {
    if ($env.PWD != $env.NOTES_HOME) {
        cd $env.NOTES_HOME
    }
    nvim index-202202270044.md
}
