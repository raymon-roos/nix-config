{...}: {
  imports = [
    ./php.nix
    ./node.nix
    ./rust.nix
    ./nix.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
