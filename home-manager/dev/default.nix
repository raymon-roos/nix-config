{...}: {
  imports = [
    ./php.nix
    ./node.nix
    ./rust.nix
    ./nix.nix
    ./python.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
