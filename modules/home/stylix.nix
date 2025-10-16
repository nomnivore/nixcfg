{
  pkgs,
  lib,
  osConfig,
  ...
}:

with lib;
{
  config = mkIf (osConfig.modules.stylix.enable) {
    stylix.targets = {
      waybar.addCss = false; # colors/fonts only

      wezterm.enable = false;
      neovim.enable = false;
      vscode.enable = false;
    };

    # user fonts
    fonts.fontconfig.enable = true;
  };
}
