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

    plover-flake.url = "github:LilleAila/plover-flake/linux-uinput-fixed";
    plover-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    kmonad.url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs:
    with inputs; let
      inherit (self) outputs;
      specialArgs = {inherit nixpkgs inputs outputs;};

      mkHomeModule = {
        host,
        args ? {},
      }: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.ray = import ./home-manager/${host}/home.nix;
          extraSpecialArgs = specialArgs // args;
        };
      };
    in {
      nixosConfigurations.raydesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          ./hosts/raydesk/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          (mkHomeModule {
            host = "raydesk";
            args = {inherit plover-flake;};
          })
        ];
      };

      darwinConfigurations."Raymons-Laptop" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        inherit specialArgs;
        modules = [
          ./hosts/raymac/configuration.nix
          stylix.darwinModules.stylix
          home-manager.darwinModules.home-manager
          (mkHomeModule {host = "raymac";})
        ];
      };
    };
}
