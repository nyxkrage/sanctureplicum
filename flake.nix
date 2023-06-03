{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    sanctureplicum-nur = {
      url = "git+https://gitea.pid1.sh/sanctureplicum/nur.git";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nekowinston-nur = {
      url = "github:nekowinston/nur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    sanctureplicum-nur,
    nekowinston-nur,
    emacs-overlay,
    nixos-wsl,
    sops-nix,
    home-manager,
    ...
  } @ inputs: let
    overlays = [
      (import emacs-overlay)
      (final: prev: let
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      in {
        nur = import nur {
          nurpkgs = unstable;
          pkgs = unstable;
          repoOverrides = {
            nekowinston = import nekowinston-nur {pkgs = unstable;};
            sanctureplicum = import sanctureplicum-nur {
              pkgs = unstable;
              system = unstable.system;
            };
          };
        };
        inherit unstable;
      })
    ];
  in {
    nixosConfigurations.falcon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
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
        ({
          config,
          pkgs,
          ...
        }: {
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
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs.overlays = overlays;
        })

        nixos-wsl.nixosModules.wsl
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.sharedModules = [
            (import ./powershell.nix)
          ];
        }
        ./hosts/buzzard
      ];
    };
    nixosConfigurations.gitea = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs.overlays = overlays;
        })

        sops-nix.nixosModules.sops
        ./hosts/gitea
      ];
    };
  };
}
