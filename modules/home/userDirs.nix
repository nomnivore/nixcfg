{
  pkgs,
  config,
  lib,
  ...
}:
let
  enabled = config.modules.nx.isDesktop;
in
with lib;
{
  config = mkIf enabled {
    xdg.userDirs.enable = true;
    xdg.userDirs.createDirectories = true;
  };
}
