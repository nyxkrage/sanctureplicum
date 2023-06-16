{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/nur";
    sanctureplicum-nur = {
      url = "git+https://gitea.pid1.sh/sanctureplicum/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nekowinston-nur = {
      url = "github:nekowinston/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane/v0.11.3";
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
    nur,
    sanctureplicum-nur,
    nekowinston-nur,
    emacs-overlay,
    nixos-wsl,
    nix-darwin,
    sops-nix,
    crane,
    home-manager,
    ...
  } @ inputs: let
    overlays = [
      (import emacs-overlay)
      (final: prev: 
        # let unstable = import nixpkgs-unstable {
        #   system = prev.system;
        #   config.allowUnfree = true;
        # }; in
        {
        nur = import nur {
          nurpkgs = prev;
          pkgs = prev;
          repoOverrides = {
            nekowinston = import nekowinston-nur {pkgs = prev;};
            sanctureplicum = import sanctureplicum-nur {
              pkgs = prev;
              system = prev.system;
            };
          };
        };
        #inherit unstable;
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
        ./hosts/common/linux.nix
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
        ./hosts/common/linux.nix
      ];
    };
    darwinConfigurations.hawk = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs.overlays = overlays;
        })

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.sharedModules = [
            sops-nix.homeManagerModule
          ];
        }
        ./hosts/hawk
        ./hosts/common/darwin.nix
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
        ./hosts/common/linux.nix
      ];
    };
    nixosConfigurations.gitea = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {craneLib = crane.lib."x86_64-linux";};
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
        ./hosts/common/linux.nix
      ];
    };
  };
}
