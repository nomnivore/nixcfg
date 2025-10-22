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
  imports = [
    ./media.nix
    ./tiling.nix
    ./utilities.nix
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {

      settings = {
        "$mod" = "SUPER"; # Windows key

        bind = [
          "$mod, RETURN, exec, $terminal"
          "$mod, W, killactive,"
          "$mod, SPACE, exec, $menu"
        ];
      };
    };
  };
}
