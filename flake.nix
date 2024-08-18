{
  description = "Ray's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # nixos-rebuild switch --flake .#raydesk
    nixosConfigurations.raydesk = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};

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
            extraSpecialArgs = {inherit inputs outputs;};
          };
        }
      ];
    };
  };
}
