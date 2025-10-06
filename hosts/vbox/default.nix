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
  ];

  time.timeZone = "America/Detroit";
  networking.hostName = "${hostname}";

  system.stateVersion = "25.05";

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # bootloader
  boot.loader.limine = {
    enable = true;
    biosDevice = "/dev/sda";
  };

  ## home-manager entry
  home-manager.users.${username} = {
    imports = [
      ../../users/kyle/home.nix
    ];
  };
}
