{ pkgs, lib, ... }:

with lib;
{
  options = {
    modules.hyprland = {
      enable = mkEnableOption "hyprland";

      package = mkPackageOption pkgs "hyprland" { };
    };
  };
}
