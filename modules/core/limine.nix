{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.limine;
  colors = config.lib.stylix.colors;
in
with lib;
{
  options = {
    modules.limine = {
      enable = mkEnableOption "limine";
    };
  };

  config = mkIf cfg.enable {
    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      biosSupport = false;

      style = {
        wallpapers = [ ]; # unset default wallpaper
        interface.branding = " "; # title at the top of the screen

        graphicalTerminal = {
          palette = "${colors.base00};${colors.base08};${colors.base0B};${colors.base0A};${colors.base0D};${colors.base0E};${colors.base0C};${colors.base05}";
          brightPalette = "${colors.base04};${colors.base08};${colors.base0B};${colors.base0A};${colors.base0D};${colors.base0E};${colors.base0C};${colors.base05}";
          background = colors.base00;
          foreground = colors.base05;
          brightBackground = colors.base04;
          brightForeground = colors.base05;
        };
      };

      # quickly boot default/most recent generation
      # mash a key to interrupt this on startup
      # except: s, space, enter, esc
      extraConfig = ''
        timeout: 1
      '';
    };
  };
}
