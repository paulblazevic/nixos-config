{
  description = "Paul's NixOS config for 5+ machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      nixos1 = pkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.paul = import ./home.nix;
        }];
      };
      nixos2 = pkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.paul = import ./home.nix;
        }];
      };
      # Add nixos3, nixos4, nixos5, etc. as needed
    };
  };
}
