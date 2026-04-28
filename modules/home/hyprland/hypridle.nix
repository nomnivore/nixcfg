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

    home.packages = with pkgs; [
      brightnessctl # only used here right now, if used elsewhere extract to its own module
    ];

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          # display timeout
          {
            timeout = 150; # 2.5m
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }

          # keyboard backlight timeout
          {
            timeout = 150; # 2.5m
            on-timeout = "brightnessctl -sd rgb:kbg_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }

          # session timeout
          {
            timeout = 300; # 5m
            on-timeout = "loginctl lock-session";
          }

          # turn screen off after locking
          {
            timeout = 300; # 5.5m
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }

          # suspend
          {
            timeout = 600; # 10m
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
