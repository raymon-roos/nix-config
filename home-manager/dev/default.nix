{...}: {
  imports = [
    ./php.nix
    ./node.nix
    ./rust.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
