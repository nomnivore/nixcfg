{
  # secrets,
  username,
  hostname,
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    ../modules/core/nix.nix
    ../modules/core/nix-ld.nix
    ../modules/core/nh.nix

    # default user
    ../modules/core/user.nix

    # set shell to zsh
    ../modules/core/zsh.nix
  ];

  time.timeZone = "America/Detroit";
  networking.hostName = "${hostname}";


  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  # enable ssh if needed
  # services.openssh.enable = true;

  home-manager.users.${username} = {
    imports = [
      ../users/kyle/home.nix
      ../modules/home/wsl.nix
    ];
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = true;
    wslConf.network.generateHosts = true;
    defaultUser = username;
    startMenuLaunchers = true;
    useWindowsDriver = true;
    # nativeSystemd = true; # systemd is now default

    # enable integration with docker desktop
    docker-desktop.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  # hardware acceleration
  # -- maybe works maybe doesn't?
  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    xsel # clipboard integration
    coreutils
    git
    nodejs
    python3
  ];
}
