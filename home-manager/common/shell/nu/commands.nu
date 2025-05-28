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
    vim flake.nix
}

def --env vimrc [] {
    if ($env.PWD != $"($env.XDG_CONFIG_HOME)/nvim") {
        cd $"($env.XDG_CONFIG_HOME)/nvim"
    }
    vim init.lua
}

def --env zettel [] {
    if ($env.PWD != $env.NOTES_HOME) {
        cd $env.NOTES_HOME
    }
    vim index-202202270044.md
}
