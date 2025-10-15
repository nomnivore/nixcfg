{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.sddm;
in
with lib;
{
  options = {
    modules.sddm = {
      enable = mkEnableOption "sddm";

      catppuccin-theme.enable = mkEnableOption "catppuccin theme";
      catppuccin-theme.flavor = mkOption {
        default = "mocha";
        example = "frappe";
        type = types.string;
      };
      catppuccin-theme.accent = mkOption {
        default = "mauve";
        example = "rose";
        type = types.string;
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = optionals (cfg.catppuccin-theme.enable) [
      (pkgs.unstable.catppuccin-sddm.override {
        flavor = cfg.catppuccin-theme.flavor;
        accent = cfg.catppuccin-theme.accent;
        font = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
        fontSize = "10";
      })
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      theme = mkIf (cfg.catppuccin-theme.enable) "catppuccin-${cfg.catppuccin-theme.flavor}-${cfg.catppuccin-theme.accent}";
    };
  };
}
