{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.cosmic;
in
with lib;
{
  options = {
    modules.cosmic = mkEnableOption "cosmic";
  };

  config = mkIf (cfg.enable) {
    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;

    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;
  };
}
