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
            nx.isDesktop = true;
            walker.enable = true;
          };
        }
      )
    ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  environment.systemPackages = with pkgs; [
    coreutils
    wl-clipboard
  ];

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
  boot = {
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.stateVersion = "25.05";
}
