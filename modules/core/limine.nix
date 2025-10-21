{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.limine;
in
with lib;
{
  options = {
    modules.limine = {
      enable = mkEnableOption "limine";
    };
  };

  config = mkIf cfg.enable {
    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      biosSupport = false;
    };
  };
}
