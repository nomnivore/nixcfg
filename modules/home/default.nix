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
    ./sh.nix
    ./wezterm.nix

    # /// Optional modules ///
    # // off by default //
    ./stylix.nix
    ./hyprland
    ./userDirs.nix
  ];
}
