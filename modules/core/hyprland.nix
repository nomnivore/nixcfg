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
  imports =
    [ ]
    ++ optionals (cfg.enable) [
      # display manager
      ./dm/regreetd.nix
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

    environment.systemPackages = with pkgs; [
      foot
      wofi
    ];

    # hint Electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    hardware.graphics.enable = true;
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
  };
}
