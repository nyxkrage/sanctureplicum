{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/nur";
    sanctureplicum-nur.url = "github:nyxkrage/sanctureplicum-nur";
    nekowinston-nur.url = "github:nekowinston/nur";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    mach-nixpkgs.url = "github:nixos/nixpkgs/9fd0585f7dc9b85eb5d426396004cc649261e60d";
    mach-nix.url = "github:davhau/mach-nix/6cd3929b1561c3eef68f5fc6a08b57cf95c41ec1";
    mach-nix.inputs.nixpkgs.follows = "mach-nixpkgs";
    mach-nix.inputs.pypi-deps-db.url = "github:davhau/pypi-deps-db/e9571cac25d2f509e44fec9dc94a3703a40126ff";
    mach-nix.inputs.pypi-deps-db.inputs.nixpkgs.follows = "mach-nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , nur
    , sanctureplicum-nur
    , nekowinston-nur
    , emacs-overlay
    , mach-nix
    , mach-nixpkgs
    , nixos-wsl
    , sops-nix
    , home-manager
    , ...
    } @inputs:
    let
      overlays = [
        (import emacs-overlay)
        (final: prev: {
          nur = import nur {
            nurpkgs = prev;
            pkgs = prev;
            repoOverrides = {
              nekowinston = import nekowinston-nur { pkgs = prev; };
              sanctureplicum = import sanctureplicum-nur { pkgs = prev; };
            };
          };
          unstable = import nixpkgs-unstable {
            system = prev.system;
            config.allowUnfree = true;
          };
          mach-nix = {
            pkgs = import mach-nixpkgs {
              system = prev.system;
              config.allowUnfree = true;
            };
            inherit mach-nix;
          };
        })
      ];
    in {
      nixosConfigurations.falcon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = overlays;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
          }
          ./hosts/falcon
        ];
      };
      nixosConfigurations.eagle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = overlays;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.sharedModules = [
              sops-nix.homeManagerModule
            ];
          }
          ./hosts/eagle
        ];
      };
      nixosConfigurations.buzzard = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = overlays;
          })
          
          nixos-wsl.nixosModules.wsl
          {
            wsl = {
              enable = true;
              wslConf.automount.root = "/mnt";
              defaultUser = "carsten";
              startMenuLaunchers = true;
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
          }
          ./hosts/buzzard
        ];
      };
      nixosConfigurations.gitea = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = overlays;
          })

          sops-nix.nixosModules.sops
          ./hosts/gitea
        ];
      };
    };
}
