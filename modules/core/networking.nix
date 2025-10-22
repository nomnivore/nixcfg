{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.networking;
in
with lib;
{
  options = {
    modules.networking = {
      enable = mkEnableOption "networking";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.wireless.iwd.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.settings = {
      Network = {
        EnableIPv6 = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };

    environment.systemPackages = with pkgs; [
      impala # iwd tui
    ];
    users.users."${username}".extraGroups = [ "networkmanager" ];
  };
}
