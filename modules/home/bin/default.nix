{
  lib,

  # any args needed by script need to be defined here
  # but each script will only receive what it needs via callModule

  pkgs,
  config,
  ...
}@args:
let
  dirContents = builtins.readDir ./.;

  # get only .nix files
  nixFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) dirContents;

  nixFilenames = builtins.attrNames nixFiles;

  callModule =
    file:
    let
      scriptFn = import ./${file};

      requiredArgs = builtins.functionArgs scriptFn;

      filteredArgs = lib.attrsets.filterAttrs (name: _: lib.attrsets.hasAttr name requiredArgs) args;
    in
    scriptFn filteredArgs;

  packages = builtins.map callModule nixFilenames;

in
{
  home.packages = packages;
}
