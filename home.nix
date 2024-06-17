# home.nix
{
  # secrets,
  pkgs,
  username,
  nix-index-database,
  config,
  ...
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

    # programming languages/toolkits
    # bun is in 'modules'
    nodejs_22
    pnpm
    go
    rustup
    gleam
  ];

  stable-packages = with pkgs; [
    # packages that are less likely to break with updates / version-conflict
    gh
    nil # nix language server
    nixfmt-rfc-style # nix formatter

    # stuff needed to make neovim config work
    gcc # c compiler
    pyenv
  ];
in
{
  imports = [
    nix-index-database.hmModules.nix-index

    ./modules/default.nix
  ];

  home.stateVersion = "23.11";

  xdg.enable = true;

  home.packages =
    stable-packages
    ++ unstable-packages
    ++ [
      # other packages that don't fit in the above lists
      # must be explicit (e.g. `pkgs.gh` instead of `gh`)
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;
  };

  home.file.".config/nix/bootstrap" = {
    source = ./bootstrap;
    executable = true;
  };
}
