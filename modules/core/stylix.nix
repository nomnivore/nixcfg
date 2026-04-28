{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.modules.stylix;
in
with lib;
{

  options = {
    modules.stylix = {
      enable = mkEnableOption "stylix";
    };
  };

  config = mkIf cfg.enable {

    fonts.fontDir.enable = true;
    fonts.fontconfig.enable = true;
    environment.systemPackages = with pkgs; [
      nerd-fonts.monaspace
      monaspace # fallback?
    ];
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      fonts = {
        # serif = {};
        # sansSerif = {};
        monospace = {
          package = pkgs.nerd-fonts.monaspace;
          name = "MonaspiceNe Nerd Font";
        };
        # emoji = {};
      };

      cursor = {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors"; # /result/share/icons/???
        size = 24;
      };
    };
  };
}
