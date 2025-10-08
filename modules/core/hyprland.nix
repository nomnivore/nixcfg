{ pkgs, ... }:

{
  # display manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # enable hyprland
  programs.hyprland.enable = true;
  programs.hyprland.extraConfig = ''
    # launcher
    bind = SUPER, SPACE, exec, wofi --show drun
  '';

  environment.systemPackages = with pkgs; [
    kitty # required for default hyprland config
    wofi
  ];

  # hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.opengl.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
}
