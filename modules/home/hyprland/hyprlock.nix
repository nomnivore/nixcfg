{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.hyprland;
  c = config.lib.stylix.colors;
  rgba = hex: alpha: "rgba(${hex}${alpha})";
  font = config.stylix.fonts.monospace.name;
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

        background = {
          monitor = "";
          path = "screenshot";
          blur_size = 6;
          blur_passes = 3;
          brightness = 0.75;
          contrast = 1.0;
          vibrancy = 0.2;
        };

        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%-I:%M %p')"'';
            font_size = 90;
            font_family = font;
            color = rgba c.base05 "ff";
            position = "0, 160";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = ''cmd[update:60000] echo "$(date +"%A, %B %-d")"'';
            font_size = 20;
            font_family = font;
            color = rgba c.base04 "ff";
            position = "0, 60";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "$USER";
            font_size = 14;
            font_family = font;
            color = rgba c.base04 "ff";
            position = "0, -60";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = mkForce [
          {
            monitor = "";
            size = "280, 48";
            outline_thickness = 2;
            dots_size = 0.28;
            dots_spacing = 0.18;
            dots_center = true;
            outer_color = rgba c.base0E "ff";
            inner_color = rgba c.base00 "88";
            font_color = rgba c.base05 "ff";
            fade_on_empty = true;
            placeholder_text = "<i>password</i>";
            fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
            check_color = rgba c.base0B "ff";
            fail_color = rgba c.base08 "ff";
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
