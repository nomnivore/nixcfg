{
  username,
  hostname,
  pkgs,
  config,
  ...
}:

{
  imports = [
    # hardware config
    # generated using `nixos-generate-config --no-filesystems --show-hardware-config > ./hardware-configuration.nix`
    ./hardware-configuration.nix

    ../common.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../users/kyle/home.nix
    ];
  };

  # my options
  modules = {
    hyprland.enable = true;

    # use only one dm
    # regreetd.enable = true; # 'cage' has issues with vbox, probably
    sddm.enable = true;
    sddm.catppuccin-theme = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };

  # following the setup described here to create 3 partitions for UEFI
  # https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning-UEFI
  # TODO: consider choosing devices by-label
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/sda3";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  swapDevices = [
    { device = "/dev/sda2"; }
    # { device = "/var/lib/swapfile"; size = 8*1024;}
  ];

  # bootloader
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    biosSupport = false;
  };

  # wayland/virtio
  environment.sessionVariables = {
    WLR_RENDER_ALLOW_SOFTWARE = "1";
  };
  environment.systemPackages = with pkgs; [
    coreutils
    xsel
    virglrenderer
  ];

  programs.firefox.enable = true;

  system.stateVersion = "25.05";
}
