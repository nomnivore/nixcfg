{
  pkgs,
  ...
}:

let
  content = builtins.readFile ./nx-search-pkgs;
in
pkgs.writeShellApplication {
  name = "nx-search-pkgs";
  runtimeInputs = with pkgs; [
    fzf
    unstable.nix-search-cli
  ];
  text = content;
}
