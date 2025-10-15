{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.regreetd;
in
with lib;
{
  options = {
    modules.regreetd = {
      enable = mkEnableOption "regreetd";
    };
  };

  config = mkIf cfg.enable {
    services.greetd.enable = true;
    programs.regreet.enable = true;
  };
}
