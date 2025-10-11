{ pkgs, ... }:

{
  imports = [
    # enabled modules
    ./bun.nix
    ./cli-apps.nix
    ./dev-tools.nix
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./sh.nix
    ./wezterm.nix

    # default disabled modules
    ./stylix.nix

    # hyprland is disabled by default
    # enable on host following @modules/core/hyprland.nix
    ./hyprland
  ];
}
