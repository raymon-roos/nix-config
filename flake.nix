{
  description = "Ray's NixOS/Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      ref = "refs/tags/v0.45.2";
    };
    hyprsplit = {
      type = "git";
      url = "https://github.com/shezdy/hyprsplit";
      ref = "refs/tags/v0.45.2";
      inputs.hyprland.follows = "hyprland";
    };

    plover-flake.url = "github:LilleAila/plover-flake/linux-uinput-fixed";
    plover-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
        args ? specialArgs,
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
