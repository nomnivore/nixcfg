{ pkgs, ... }:

{
  # display manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # enable hyprland
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    foot
    wofi
  ];

  # hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.opengl.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
}
