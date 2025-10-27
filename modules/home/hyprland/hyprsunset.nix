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
    home.packages = with pkgs; [
      hyprsunset
    ];

    wayland.windowManager.hyprland = {
      settings.exec-once = [ "uwsm app -- hyprsunset" ];
    };

    # default temperature is 6000
    xdg.configFile."hypr/hyprsunset.conf".text = ''
      profile {
        time = 07:00
        identity = true
      }

      profile {
        time = 21:00
        temperature = 4000
      }
    '';
  };
}
