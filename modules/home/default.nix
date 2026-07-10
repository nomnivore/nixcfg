{ pkgs, ... }:

{
  imports = [
    # /// Always-on modules ///
    ./bun.nix
    ./cli-apps.nix
    ./dev-tools.nix
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./external-engine.nix
    ./agents.nix
    ./sh.nix
    ./wezterm.nix

    ./bin # shell scripts

    # /// Optional modules ///
    # // off by default //
    ./desktop.nix
    ./stylix.nix
    ./hyprland
    ./walker
  ];
}
