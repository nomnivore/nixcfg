{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    # terminal multiplexer
    zellij

    # tui apps
    lazygit
    # TODO: pick a file manager
    nnn
    yazi
  ];
}
