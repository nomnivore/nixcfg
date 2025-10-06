{ pkgs, ... }:

{
  # allows dynamically linked libraries
  # works better for vscode integration, but may interfere with other programs (?)
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

}
