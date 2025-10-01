{ config, lib, ... }:

{
  # Define an enable option for each module you want to make toggleable.
  options.modules = {
    bun = lib.mkEnableOption "Bun package and versioning";
    neovim = lib.mkEnableOption "Neovim editor configuration";
    sh = lib.mkEnableOption "Shell configuration (zsh, aliases, etc)";
    wezterm = lib.mkEnableOption "Wezterm terminal configuration";
    packages = lib.mkEnableOption "Base set of packages";
    git = lib.mkEnableOption "Git and GitHub tooling";
    dev-tools = lib.mkEnableOption "Developer tools and languages";
    cli-apps = lib.mkEnableOption "CLI and TUI applications";
  };

  # Conditionally import modules based on the options defined above.
  imports = [
    (lib.mkIf config.modules.bun.enable ./bun.nix)
    (lib.mkIf config.modules.neovim.enable ./neovim.nix)
    (lib.mkIf config.modules.sh.enable ./sh.nix)
    (lib.mkIf config.modules.wezterm.enable ./wezterm.nix)
    (lib.mkIf config.modules.packages.enable ./packages.nix)
    (lib.mkIf config.modules.git.enable ./git.nix)
    (lib.mkIf config.modules.dev-tools.enable ./dev-tools.nix)
    (lib.mkIf config.modules.cli-apps.enable ./cli-apps.nix)
  ];

  # Set the default value for each module to enabled.
  config = {
    modules.bun.enable = lib.mkDefault true;
    modules.neovim.enable = lib.mkDefault true;
    modules.sh.enable = lib.mkDefault true;
    modules.wezterm.enable = lib.mkDefault true;
    modules.packages.enable = lib.mkDefault true;
    modules.git.enable = lib.mkDefault true;
    modules.dev-tools.enable = lib.mkDefault true;
    modules.cli-apps.enable = lib.mkDefault true;
  };
}

