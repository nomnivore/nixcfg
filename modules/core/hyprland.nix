{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.hyprland;
in

with lib;
{
  imports = [
    # display manager
    # TODO: these should get imported elsewhere, as they dont implicitly have a relationship with hyprland
    ./dm/regreetd.nix
    ./dm/sddm.nix
  ];

  options = {
    modules.hyprland = {
      enable = mkEnableOption "hyprland";

      package = mkPackageOption pkgs "hyprland" { };

    };
  };

  config = mkIf cfg.enable {

    # enable hyprland
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.hyprland.package = cfg.package;

    # Backport of nixpkgs commit 184d1b4c0 (upstream on unstable, not yet
    # on nixos-26.05): without this, switching restarts uwsm's session
    # units and kills the whole graphical session.
    # TODO: drop this once the nixpkgs pin moves past 26.05 (e.g. 26.11)
    # and includes the backport upstream.
    systemd.user.services = genAttrs [ "wayland-wm@" "wayland-session-bindpid@" ] (_: {
      restartIfChanged = false;
      enableDefaultPath = false; # avoid clobbering uwsm's own PATH
    });

    # hint Electron apps to use Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    hardware.graphics.enable = true;
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
  };
}
