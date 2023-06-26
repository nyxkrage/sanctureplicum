{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/nur";
    sanctureplicum-nur = {
      url = "git+https://gitea.pid1.sh/sanctureplicum/nur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nekowinston-nur = {
      url = "github:nekowinston/nur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    nix-darwin,
    sops-nix,
    crane,
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
        inherit unstable;
      })
    ];
    overlayModule = {
      config,
      pkgs,
      ...
    }: {
      nixpkgs.overlays = overlays;
    };
    hmConfig = sops: [
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.sharedModules =
          if sops
          then [
            sops-nix.homeManagerModule
          ]
          else [];
        home-manager.extraSpecialArgs = {inherit inputs;};
      }
      ./users/carsten
    ];
    mkSystem = {
      host,
      system,
      hm ? true,
      wsl ? false,
      sops ? false,
      sops-hm ? false,
      modules ? [],
    }: let
      isDarwin = builtins.match ".+?-linux" == null;
      builder =
        if isDarwin
        then nix-darwin.lib.darwinSystem
        else nixpkgs.lib.nixosSystem;
      hmModule =
        if isDarwin
        then home-manager.darwinModules.home-manager
        else home-manager.nixosModules.home-manager;
      sopsModule =
        if isDarwin
        then sops-nix.darwinModules.sops
        else sops-nix.nixosModules.sops;
      systemModule =
        if isDarwin
        then ./hosts/common/darwin.nix
        else ./hosts/common/linux.nix;
    in
      builder {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules =
          [
            overlayModule
            (./hosts + "/${host}")
            systemModule
          ]
          ++ (
            if hm
            then [hmModule] ++ (hmConfig sops-hm)
            else []
          )
          ++ (
            if wsl
            then [nixos-wsl.nixosModules.wsl]
            else []
          )
          ++ (
            if sops
            then [sopsModule]
            else []
          )
          ++ modules;
      };
  in {
    nixosConfigurations.falcon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules =
        [
          overlayModule

          home-manager.nixosModules.home-manager
          ./hosts/falcon
          ./hosts/common/linux.nix
        ]
        ++ hmConfig;
    };
    nixosConfigurations.eagle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules =
        [
          overlayModule

          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              sops-nix.homeManagerModule
            ];
          }
          ./hosts/eagle
          ./hosts/common/linux.nix
        ]
        ++ hmConfig;
    };
    darwinConfigurations.hawk = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules =
        [
          overlayModule
          home-manager.darwinModules.home-manager
          {
            home-manager.sharedModules = [
              sops-nix.homeManagerModule
            ];
          }
          ./hosts/hawk
          ./hosts/common/darwin.nix
        ]
        ++ hmConfig;
    };

    nixosConfigurations.buzzard = mkSystem {
      host = "buzzard";
      system = "x86_64-linux";
      wsl = true;
    };
    # nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   specialArgs = {
    #     inherit inputs;
    #   };
    #   modules =
    #     [
    #       overlayModule

    #       nixos-wsl.nixosModules.wsl
    #       home-manager.nixosModules.home-manager
    #       ./hosts/buzzard
    #       ./hosts/common/linux.nix
    #     ]
    #     ++ hmConfig;
    # };
    nixosConfigurations.gitea = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        craneLib = crane.lib."x86_64-linux";
      };
      modules = [
        overlayModule
        sops-nix.nixosModules.sops
        ./hosts/gitea
        ./hosts/common/linux.nix
      ];
    };
  };
}
