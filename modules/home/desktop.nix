# Modules that are enabled when any window manager or desktop environment is enabled
# aka : not a CLI only setup
# TODO: move this all to a nx/ folder?
{
  pkgs,
  config,
  lib,
  ...
}:
let
  isDesktop = config.modules.hyprland.enable;
  cfg = config.modules.nx;
in
with lib;
{
  imports = [
    ./userDirs.nix
  ];
  options.modules.nx = {
    isDesktop = mkOption {
      default = isDesktop;
      example = true;
      description = "Whether this is a desktop environment";
      type = types.bool;
    };
  };
  config = mkIf cfg.isDesktop {
    programs.firefox.enable = true;
    # programs.obsidian.enable = true; # only available in 'unstable' for now

    home.packages = with pkgs.unstable; [
      bitwarden-desktop
      obsidian
    ];

    # web apps
    # icons from https://dashboardicons.com/
    xdg.desktopEntries = {
      gemini = {
        name = "Gemini";
        exec = "nx-launch-webapp https://gemini.google.com";
        icon = pkgs.fetchurl {
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-gemini.png";
          sha256 = "sha256-U16hXdmDWtsO9308rxhnmHBQMMe0QO7mySL2wMugBiM=";
        };
        type = "Application";
      };

      github = {
        name = "GitHub";
        exec = "nx-launch-webapp https://github.com";
        icon = pkgs.fetchurl {
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png";
          sha256 = "sha256-BFLUsd6GVtiudyS5M5JGtRLdvO/5G5mjYVp05zW7x6o=";
        };
        type = "Application";
      };
    };
  };
}
