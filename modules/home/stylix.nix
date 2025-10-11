{ pkgs, lib, osConfig, ... }:

with lib;
{
  config = mkIf (osConfig.stylix.enable) {
    stylix.targets = {
      wezterm.enable = false;
      neovim.enable = false;
      obsidian.enable = false;
      vscode.enable = false;
    };
  };
}
