{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.userDirs;
in
with lib;
{
  options.modules.userDirs = {
    enable = lib.mkEnableOption "user directories";
  };

  config = mkIf cfg.enable {
    xdg.userDirs.enable = true;
    xdg.userDirs.createDirectories = true;
  };
}
