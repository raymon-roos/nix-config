{
  description = "Ray's Home Manager configuration";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprsplit.url = "github:shezdy/hyprsplit";
    hyprsplit.inputs.hyprland.follows = "hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    hyprland,
    hyprsplit,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";

    pkgs-unstable = import inputs.unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.raydesk = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit pkgs-unstable inputs outputs;
      };

      modules = [
        ./nixos/configuration.nix

        stylix.nixosModules.stylix
        ./stylix.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ray = import ./home-manager/home.nix;
            extraSpecialArgs = {
              inherit pkgs-unstable hyprland hyprsplit inputs outputs;
            };
          };
        }
      ];
    };
  };
}
