{...}: {
  imports = [
    ./php.nix
    ./nodejs.nix
    ./rust.nix
    ./nix.nix
    ./python.nix
    ./go.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c20)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/$hash$path"
          )}"
      }
    '';
  };
}
