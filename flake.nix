# flake.nix

# ref https://github.com/LGUG2Z/nixos-wsl-starter/blob/master/flake.nix

{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # community packages
    nur.url = "github:nix-community/NUR";

    # wsl
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # index database (what is this?)
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # neovim-cfg = {
    #   url = "github:nomnivore/nvim";
    #   flake = false;
    # };

  };

  outputs = inputs:
    with inputs; let
      #TODO: secrets
      # secrets = builtins.fromJSON (builtins.readFile ./secrets.json);
      nixpkgsWithOverlays = system: (import nixpkgs rec {
        inherit system;

        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ ];
        };

        overlays = [
          nur.overlay
          neovim-nightly-overlay.overlays.default
          # inline: adds 'unstable' for more recent packages
          # ex: pkgs.unstable.vim
          (_final: prev: {
            unstable = import nixpkgs-unstable
              {
                inherit (prev) system;
                inherit config;
              };
            bun-latest = prev.bun.overrideAttrs
              (final: bprev: rec {
                version = "1.1.13";
                src = passthru.sources.${prev.stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${prev.stdenvNoCC.hostPlatform.system}");
                passthru = bprev.passthru // {
                  sources = bprev.passthru.sources // {
                    "x86_64-linux" = prev.fetchurl {
                      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
                      hash = "sha256-QC6dsWjRYiuBIojxPvs8NFMSU6ZbXbZ9Q/+u+45NmPc=";
                    };
                  };
                };
              });
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
        inherit inputs self nix-index-database;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };

      mkNixosConfiguration =
        { system ? "x86_64-linux"
        , hostname
        , username
        , args ? { }
        , modules
        ,
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
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      nixosConfigurations.nixos = mkNixosConfiguration {
        hostname = "nixos";
        username = "kyle";
        modules = [
          nixos-wsl.nixosModules.wsl
          ./wsl.nix
        ];
        args = { inherit neovim-nightly-overlay; };
        # args = {
        #   inherit neovim-cfg;
        # };
      };
    };
}
