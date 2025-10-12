{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    # terminal multiplexer
    zellij
  ];

  # tui apps
  programs.lazygit.enable = true;
  programs.lazygit.package = pkgs.unstable.lazygit;

  # TODO: pick a file manager
  programs.yazi.enable = true;
  programs.yazi.package = pkgs.unstable.yazi;
  programs.nnn.enable = true;
  programs.nnn.package = pkgs.unstable.nnn;
}
