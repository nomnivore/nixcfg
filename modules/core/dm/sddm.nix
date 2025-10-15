{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.sddm;
in
with lib;
{
  options = {
    modules.sddm = {
      enable = mkEnableOption "sddm";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  };
}
