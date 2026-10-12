{
  description = "NixOS system-wide Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "home-manager";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            inputs.plasma-manager.homeModules.plasma-manager
          ];
        }

        {
          virtualisation.vmVariant = {
            virtualisation = {
              memorySize = 4096;
              cores = 4;
            };

            users.users.noahjaye.initialPassword = "vm";
          };
        }
      ];
    };
  };
}
