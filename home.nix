# home.nix
{
  # secrets,
  pkgs
, username
, nix-index-database
, config
, lib
, neovim-nightly-overlay
  # , neovim-cfg
, ...
}:
let
  unstable-packages = with pkgs.unstable; [
    # core binaries/programs that will always be bleeding-edge
    # TODO: take programs from the wsl.nix file
    neofetch # hello world :)
    zsh-powerlevel10k

    # cli tools
    wget
    vim
    git
    curl
    unzip
    ripgrep
    fd
    lsd

    # tui apps
    lazygit
    # TODO: pick a file manager
    superfile
    walk
    nnn

    # programming languages
    nodejs_22
    bun
  ];

  stable-packages = with pkgs; [
    # packages that are less likely to break with updates / version-conflict
    gh
    nil # nix language server
    nixpkgs-fmt # nix formatter

    # stuff needed to make neovim config work
    gcc # c compiler
    pyenv
  ];
in
{
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "23.11";

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # other packages that don't fit in the above lists
    [
      pkgs.cowsay # TODO: remove
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    neovim =
      {
        enable = true;
        defaultEditor = true;
        package = neovim-nightly-overlay.packages.${pkgs.system}.default;
      };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      plugins = with pkgs; [
        {
          name = "powerlevel10k.zsh-theme";
          file = "powerlevel10k.zsh-theme";
          src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
        }
        {
          name = "powerlevel10k-config";
          file = ".p10k.zsh";
          src = ./zsh;
        }
      ];
      initExtraBeforeCompInit = builtins.readFile ./zsh/p10k_instant_prompt.zsh;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "z"
        ];
        extraConfig = ''
          zstyle ':completion:*' menu select
        '';
      };
    };

  };

  home.shellAliases =
    {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixcfg";
      win = "powershell.exe";
      ls = "lsd";
    };

  # FIXME: this may need to be a derivation? not sure how it would work if offline.
  # TODO: dedupe code with 'bootstrap' script
  home.activation.setup-neovim = lib.hm.dag.entryAfter
    [ "writeBoundary" ]
    ''
      PATH=$PATH:${lib.makeBinPath [pkgs.git]}

      TARGET_DIR="$HOME/.config/nvim"

      REPO_URL="https://github.com/nomnivore/nvim.git"

      if [ -d "$TARGET_DIR/.git" ]; then
        echo "Neovim config exists in $TARGET_DIR, pulling latest changes..."
        run git -C "$TARGET_DIR" pull --force
      else
        echo "Git repository not found in $TARGET_DIR, cloning repository..."
        run git clone "$REPO_URL" "$TARGET_DIR"
      fi
    '';

  home.file.".config/nix/bootstrap" = {
    source = ./bootstrap;
    executable = true;
  };

  # home.file.".p10k.zsh".source = ./.p10k.zsh;
}
