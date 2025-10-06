{ pkgs, username, ... }:

{
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  users.users.${username}.shell = pkgs.zsh;

  # completion for system packages
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
}
