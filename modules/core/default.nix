{ pkgs, ... }:

{
  imports = [
    # /// Always-on modules ///
    ../modules/core/nix.nix
    ../modules/core/nix-ld.nix
    ../modules/core/nh.nix
    # default user
    ../modules/core/user.nix
    # set shell to zsh
    ../modules/core/zsh.nix


    # /// Optional modules ///
    # // off by default //
    # styles
    ../../modules/core/stylix.nix
    # desktops
    ../../modules/core/hyprland.nix
    ../../modules/core/cosmic.nix
  ];
}
