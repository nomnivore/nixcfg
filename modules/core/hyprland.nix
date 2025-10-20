{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.hyprland;
in

with lib;
{
  imports = [
    # display manager
    # TODO: these should get imported elsewhere, as they dont implicitly have a relationship with hyprland
    ./dm/regreetd.nix
    ./dm/sddm.nix
  ];

  options = {
    modules.hyprland = {
      enable = mkEnableOption "hyprland";

      package = mkPackageOption pkgs "hyprland" { };

    };
  };

  config = mkIf cfg.enable {

    # enable hyprland
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.hyprland.package = cfg.package;

    # hint Electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    hardware.graphics.enable = true;
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
  };
}
