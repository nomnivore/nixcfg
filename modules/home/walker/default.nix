{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.walker;
  colors = config.lib.stylix.colors.withHashtag;
in
with lib;
{
  imports = [ inputs.walker.homeManagerModules.default ];

  options.modules.walker = {
    enable = mkEnableOption "walker";
  };

  config = mkIf cfg.enable {

    # possible fix for Error 22 Display issue:
    home.packages = [
      pkgs.unstable.gtk4-layer-shell
    ];

    programs.walker = {
      enable = true;
      runAsService = true;

      config = {
        theme = "omarchy";
      }
      // builtins.fromTOML (builtins.readFile ./config.toml);

      themes = {
        "omarchy" = {
          style = ''
            @define-color selected-text ${colors.base07};
            @define-color text ${colors.base05};
            @define-color base ${colors.base00};
            @define-color border ${colors.base0D};
            @define-color background ${colors.base00};
            @define-color foreground ${colors.base05};

            ${builtins.readFile ./omarchy-style.css}
          '';

          layouts = {
            "layout" = builtins.readFile ./omarchy-layout.xml;
          };
        };
      };
    };
  };

  # TODO: theme with stylix
}
