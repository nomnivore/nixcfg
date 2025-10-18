{ pkgs, config, lib, username, ... }:
let
cfg = config.modules.networking;
in with lib;
{
  options = {
    modules.networking = {
      enable = mkEnableOption "networking";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    users.users."${username}".extraGroups = [ "networkmanager" ];
  };
}
