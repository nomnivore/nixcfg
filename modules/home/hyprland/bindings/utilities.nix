{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.hyprland;
in
with lib;
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {

      settings = {
        #
      };
    };
  };
}
