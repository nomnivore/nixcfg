{
  username,
  hostname,
  pkgs,
  config,
  ...
}:
let
  # modules that are defined in both core and home, to be grouped together
  sharedModules = {
    hyprland.enable = true;
  };
in
{
  imports = [
    # hardware config
    # generated using `nixos-generate-config --no-filesystems --show-hardware-config > ./hardware-configuration.nix`
    ./hardware-configuration.nix

    ../common.nix
  ];
  # my system options
  modules = sharedModules // {
    stylix.enable = true; # TODO: move this to sharedModules without breaking the attr merge in home/stylix.nix
    limine.enable = true;
    # use only one dm
    # regreetd.enable = true; # 'cage' has issues with vbox, probably
    sddm.enable = true;
    sddm.catppuccin-theme = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
    pipewire.enable = true;
    networking.enable = true;
  };

  home-manager.users.${username} = {
    imports = [
      ../../users/kyle/home.nix

      (
        { pkgs, ... }:
        {
          modules = sharedModules // {
            # my home options
            userDirs.enable = true;
          };
        }
      )
    ];
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

  # wayland/virtio
  environment.sessionVariables = {
    WLR_RENDER_ALLOW_SOFTWARE = "1";
  };
  environment.systemPackages = with pkgs; [
    coreutils
    wl-clipboard
    virglrenderer
  ];

  programs.firefox.enable = true;

  system.stateVersion = "25.05";
}
