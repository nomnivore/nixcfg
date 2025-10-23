{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.walker;
in
with lib;
{
  imports = [ inputs.walker.homeManagerModules.default ];

  options.modules.walker = {
    enable = mkEnableOption "walker";
  };

  config = mkIf cfg.enable {

    # possible fix for Error 22 Display issue:
    home.packages = [
      pkgs.unstable.gtk4-layer-shell
    ];

    programs.walker = {
      enable = true;
      runAsService = true;
    };
  };

  # TODO: theme with stylix
}
