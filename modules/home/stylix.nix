{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:

with lib;
{
  config =
    { }
    // optionalAttrs osConfig.modules.stylix.enable {
      # 'stylix' does not exist in home-manager unless the NixOS module is enabled
      stylix = {
        targets = {
          waybar.addCss = false; # colors/fonts only

          wezterm.enable = false;
          neovim.enable = false;
          vscode.enable = false;
        };

        # user fonts
        fonts.fontconfig.enable = true;
      };
    };
}
