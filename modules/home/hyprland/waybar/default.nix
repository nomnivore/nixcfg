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
    programs.wlogout.enable = true;
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      # merge with stylix color declarations
      style = lib.mkAfter (builtins.readFile ./style.css);
    };

    # symlink
    xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
  };
}
