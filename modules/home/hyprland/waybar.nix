{ pkgs, ... }:

{
  programs.waybar.enable = true;

  wayland.windowManager.hyprland = {
    settings.exec-once = [ "uwsm app -- waybar" ];
  };
}
