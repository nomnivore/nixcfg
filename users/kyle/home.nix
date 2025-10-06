{
  # secrets,
  pkgs,
  nix-index-database,
  username,
  config,
  ...
}:
let
  # this could be split into seperate files
  # contained in modules, each containing setup related to their module
  bootstrapScript = pkgs.writeShellScriptBin "bootstrap" (builtins.readFile ../../bin/bootstrap);
in
{
  imports = [
    nix-index-database.homeModules.nix-index
    ../../modules/home
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.11";

  xdg.enable = true;

  home.packages = [
    bootstrapScript
  ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    # TODO: setup gpg
    # probably needs secrets management
    # otherwise creating/setting keys will need to be manual
  };
}
