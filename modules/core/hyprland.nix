{ pkgs, ... }:

{
  services.displayManager.sddm.wayland.enable = true;
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    kitty # required for default hyprland config
  ];

  # hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
