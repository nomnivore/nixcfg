{ pkgs, lib, ... }:

{
  # config/keybind docs/etc
  home.file.".config/wezterm".source = ./wezterm;

  # program
  programs.wezterm.enable = true;
  # even if we don't need the whole program (like on WSL)
  # the binary helps enable some functionality

  # ex: multiplexer spawning new tabs in same CWD
}
