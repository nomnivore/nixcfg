{
  username,
  hostname,
  pkgs,
  ...
}:

{
  imports = [
    # hardware config
    # generated using `nixos-generate-config --no-filesystems --show-hardware-config > ./hardware-configuration.nix`
    ./hardware-configuration.nix

    ../../modules/core/nix.nix
    ../../modules/core/nix-ld.nix
    ../../modules/core/nh.nix

    # default user
    ../../modules/core/user.nix

    # set shell to zsh
    ../../modules/core/zsh.nix

    # desktop environment
    # cosmic
    # ../../modules/core/cosmic.nix
    # hyprland
    ../../modules/core/hyprland.nix
  ];

  time.timeZone = "America/Detroit";
  networking.hostName = "${hostname}";

  system.stateVersion = "25.05";

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

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
    virglrenderer
  ];

  ## home-manager entry
  home-manager.users.${username} = {
    imports = [
      ../../users/kyle/home.nix
    ];
  };
}
