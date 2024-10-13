{...}: {
  imports = [
    ./php.nix
    ./node.nix
    ./rust.nix
    ./nix.nix
    ./python.nix
    # ./go.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
