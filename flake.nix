{
  description = "Ray's NixOS/Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsplit.url = "github:shezdy/hyprsplit";
    hyprsplit.inputs.hyprland.follows = "hyprland";

    plover-flake.url = "github:LilleAila/plover-flake/linux-uinput-fixed";
    plover-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations.raydesk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {inherit inputs outputs;};

      modules = with inputs; [
        ./nixos/configuration.nix

        stylix.nixosModules.stylix
        ./stylix.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ray = import ./home-manager/home.nix;
            extraSpecialArgs = {inherit inputs outputs plover-flake;};
          };
        }
      ];
    };
  };
}
