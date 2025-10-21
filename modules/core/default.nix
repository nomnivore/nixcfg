{ pkgs, ... }:

{
  imports = [
    # /// Always-on modules ///
    ./nix.nix

    ./nix-ld.nix
    ./nh.nix
    # default user
    ./user.nix
    # set shell to zsh
    ./zsh.nix

    # /// Optional modules ///
    # // off by default //
    ./limine.nix
    ./pipewire.nix
    ./networking.nix
    # styles
    ./stylix.nix
    # desktops
    ./hyprland.nix
    ./cosmic.nix
  ];
}
