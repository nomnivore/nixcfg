{ pkgs, ... }:

{
  imports = [
    ./bun.nix
    ./cli-apps.nix
    ./dev-tools.nix
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./sh.nix
    ./wezterm.nix

    # hyprland is disabled by default
    # enable on host following @modules/core/hyprland.nix
    ./hyprland
  ];
}
