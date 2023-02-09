{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @inputs: {
      nixosConfigurations.falcon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/falcon

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
          }
        ];
      };
      nixosConfigurations.eagle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [
              (import (builtins.fetchTarball {
                url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
                sha256 = "05941qsk7138ylfpzqcqcgrpjw0jnyh2r1q6nhyh7n3d5q00hc8b";
              }))
            ];
          })
          ./hosts/eagle

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
          }
        ];
      };
    };
}
