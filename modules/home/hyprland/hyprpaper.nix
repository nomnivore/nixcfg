{
  pkgs,
  config,
  lib,
  ...
}:

let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/minimalistic/dark-cat-rosewater.png";
    sha256 = "1bif87s8cxlg4k58yj5816v174vqbn4p4fqlzv2rnhj69jszpy0z";
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
