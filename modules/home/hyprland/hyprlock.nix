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
  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          ignore_empty_input = true;
        };
      };
    };
  };
}
