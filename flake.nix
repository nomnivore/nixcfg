# flake.nix

# ref https://github.com/LGUG2Z/nixos-wsl-starter/blob/master/flake.nix

{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # stylix - must be same as nixpkgs.url version
    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # community packages
    nur.url = "github:nix-community/NUR";

    # wsl
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # index database (what is this?)
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs:
    with inputs;
    let
      #TODO: secrets
      # secrets = builtins.fromJSON (builtins.readFile ./secrets.json);
      nixpkgsWithOverlays =
        system:
        (import nixpkgs rec {
          inherit system;

          config = {
            allowUnfree = true;
            permittedInsecurePackages = [ ];
          };

          overlays = [
            nur.overlays.default
            neovim-nightly-overlay.overlays.default
            # inline: adds 'unstable' for more recent packages
            # ex: pkgs.unstable.vim
            (_final: prev: {
              unstable = import nixpkgs-unstable {
                inherit (prev) system;
                inherit config;
              };
            })
          ];
        });

      configurationDefaults = args: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = {
        #TODO: add secrets to this list
        inherit
          inputs
          self
          nix-index-database
          neovim-nightly-overlay
          ;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
        vars = {
          flakePath = "nixcfg"; # directory (within $HOME) where nix configuration is stored (this repo)
        };
      };

      mkNixosConfiguration =
        {
          system ? "x86_64-linux",
          hostname,
          username,
          args ? { },
          modules,
        }:
        let
          specialArgs = argDefaults // { inherit hostname username; } // args;
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          pkgs = nixpkgsWithOverlays system;
          modules = [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
          ]
          ++ modules;
        };

      mkHomeConfiguration =
        {
          system ? "x86_64-linux",
          username,
          args ? { },
          modules,
        }:
        let
          specialArgs = argDefaults // { inherit username; } // args;
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsWithOverlays system;
          extraSpecialArgs = specialArgs;
          modules = modules;
        };
    in
    {
      nixosConfigurations.nixos = mkNixosConfiguration {
        # config for my WSL2 setup
        hostname = "nixos";
        username = "kyle";
        modules = [
          stylix.nixosModules.stylix

          nixos-wsl.nixosModules.wsl
          ./hosts/wsl.nix
        ];
      };

      nixosConfigurations.vbox = mkNixosConfiguration {
        # config for a virtualbox setup
        hostname = "vbox";
        username = "kyle";
        modules = [
          stylix.nixosModules.stylix
          ./hosts/vbox
        ];
      };

      homeConfigurations.kyle = mkHomeConfiguration {
        # config for standalone nix running on other distros (using home-manager)
        username = "kyle";
        modules = [ ./users/kyle/home.nix ];
      };
    };
}
