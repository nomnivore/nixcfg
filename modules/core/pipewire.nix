# PipeWire is a low-level multimedia framework (audio playback/recording)

{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.pipewire;
in
with lib;
{
  options = {
    modules.pipewire = {
      enable = mkEnableOption "pipewire";
    };
  };
  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
