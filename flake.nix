{
  description = "Ray's NixOS/Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    secrets.url = "git+ssh://git@github.com/raymon-roos/nix-secrets";
    secrets.flake = false;

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    flake-registry.url = "github:nixos/flake-registry";
    flake-registry.flake = false;

    watt.url = "github:NotAShelf/watt";
    watt.inputs.nixpkgs.follows = "nixpkgs";

    maomaowm.url = "github:DreamMaoMao/maomaowm/refs/tags/0.7.0";
    maomaowm.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    plover-flake.url = "github:dnaq/plover-flake";
    plover-flake.inputs.nixpkgs.follows = "nixpkgs";

    lyrical.url = "github:raymon-roos/lyrical-rs";
    lyrical.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs:
    with inputs; let
      inherit (self) outputs;
      specialArgs = {inherit nixpkgs inputs outputs;};
    in {
      nixosConfigurations.raydesk = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/raydesk/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          maomaowm.nixosModules.maomaowm
        ];
      };

      nixosConfigurations.raytop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/raytop/configuration.nix
          disko.nixosModules.disko
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          watt.nixosModules.watt
        ];
      };
    };
}
