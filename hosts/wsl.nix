{
  # secrets,
  username,
  hostname,
  pkgs,
  inputs,
  vars,
  ...
}:
{

  imports = [
    ../modules/core/nix-ld.nix
  ];

  time.timeZone = "America/Detroit";
  networking.hostName = "${hostname}";

  # set shell to zsh
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  # enable ssh if needed
  # services.openssh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];

    # FIXME: add password
    # hashedPassword = "";
    # FIXME: add ssh public key
    # openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];
  };

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

  programs.nh = {
    enable = true;
    flake = "/home/${username}/${vars.flakePath}";
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  nix = {
    settings = {
      trusted-users = [ username ];
      # FIXME: access tokens for github and gitlab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      # prefer 'unstable' for nix-shell etc
      "nixpkgs=${inputs.nixpkgs-unstable.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      # FIXME: the overlays-compat trick doesn't work at all for me.
      "nixpkgs-overlays=${toString ../overlays-compat}"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''experimental-features = nix-command flakes'';

    # disabled due to 'nh.clean.enable'
    gc = {
      automatic = false;
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    xsel # clipboard integration
    coreutils
    git
    nodejs
    python3
  ];
}
