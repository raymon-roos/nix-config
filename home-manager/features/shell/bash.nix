{ pkgs, config, inputs, ... }:
let
  stateHome = config.xdg.stateHome;
  configHome = config.xdg.configHome;
in
{
  programs.bash = {
    enable = false;
    enableCompletion = true;
    historyFile = "${stateHome}/bash/history";
    historyControl = [ "erasedups" ];
    historyIgnore = [ "ls" "y" "pwd" "cd" "fg %" "exit" "sudo poweroff*" "builtin cd -- *" ];
    profileExtra = ''
      # autostart compositor of choice when logging in on tty1
      if [[ "$XDG_VTNR" == 1 ]]; then
          hyprland
      fi
    '';
    initExtra = ''
      # hack to fix dynamically linked binaries for traditional distros
      NIX_LD="$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')"
      export NIX_LD
    '';
    bashrcExtra = builtins.readFile ./functions.sh;
  };
}
