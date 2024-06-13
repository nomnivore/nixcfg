{
  # secrets,
  username
, hostname
, pkgs
, inputs
, ...
}: {
  time.timeZone = "America/Detroit";
  networking.hostName = "${hostname}";

  # set shell to zsh
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  # enable ssh if needed
  # services.openssh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];

    # FIXME: add password
    # hashedPassword = "";
    # FIXME: add ssh public key
    # openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
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

    # enable integration with docker desktop
    # (for now, WSL:Ubuntu is taking care of this)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294
  # systemd.user = {
  #   paths.vscode-remote-workaround = {
  #     wantedBy = ["default.target"];
  #     pathConfig.PathChanged = "%h/.vscode-server/bin";
  #   };
  #   services.vscode-remote-workaround.script = ''
  #     for i in ~/.vscode-server/bin/*; do
  #       if [ -e $i/node ]; then
  #         echo "Fixing vscode-server in $i..."
  #         ln -sf ${pkgs.nodejs_18}/bin/node $i/node
  #       fi
  #     done
  #   '';
  # };

  # allows dynamically linked libraries
  # works better for vscode integration, but may interfere with other programs (?)
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
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
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];


    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    xsel # clipboard integration
  ];
}
