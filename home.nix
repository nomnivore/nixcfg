{
  # secrets,
  pkgs
, username
, nix-index-database
, ...
}:
let
  unstable-packages = with pkgs.unstable; [
    # core binaries/programs that will always be bleeding-edge
    # TODO: take programs from the wsl.nix file
    neofetch # hello world :)

    wget
    vim
    git
    curl

  ];

  stable-packages = with pkgs; [
    # packages that are less likely to break with updates / version-conflict
    gh
    nil # nix language server
    nixpkgs-fmt # nix formatter
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
  };
}
