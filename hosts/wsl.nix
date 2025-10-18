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
    ./common.nix

  ];

  home-manager.users.${username} = {
    imports = [
      ../users/kyle/home.nix
      ../modules/home/wsl.nix

      (
        { pkgs, ... }:
        {
          home.shellAliases = {
            winhome = "(cd /mnt/c; echo /mnt/c/Users/$(cmd.exe /c \"echo %USERNAME%\" | tr -d \"\r\") )";
            wslsurf = "windsurf --remote wsl+nixos $1";
          };
        }
      )
    ];
  };

  # my options
  modules = { };

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

  system.stateVersion = "23.11";
}
