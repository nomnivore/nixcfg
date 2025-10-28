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
  };
}
