{
  pkgs,
  config,
  lib,
  ...
}:

let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/landscapes/forrest.png";
    sha256 = "sha256-jDqDj56e9KI/xgEIcESkpnpJUBo6zJiAq1AkDQwcHQM=";
  };
  cfg = config.modules.hyprland;
in
with lib;
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    wayland.windowManager.hyprland = {
      settings.exec-once = [ "uwsm app -- hyprpaper" ];
    };

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = , ${wallpaper}
    '';
  };
}
