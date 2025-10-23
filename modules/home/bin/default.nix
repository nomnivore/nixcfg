{
  pkgs,
  lib,
  ...
}@args:
let
  dirContents = builtins.readDir ./.;

  # get only .nix files
  nixFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) dirContents;

  nixFilenames = builtins.attrNames nixFiles;

  packages = builtins.map (file: (import ./${file}) args) nixFilenames;

in
{
  home.packages = packages;
}
