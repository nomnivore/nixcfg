# use all modules defined in this directory

{ config, pkgs, ... }:

{
  imports = [
    # adds the `bun` package and allows for explicit versioning
    ./bun.nix

    ./neovim.nix
    ./sh.nix

    ./wezterm.nix

    # new modules
    ./packages.nix
    ./git.nix
    ./dev-tools.nix
    ./cli-apps.nix
  ];
}
