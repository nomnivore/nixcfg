{ pkgs, ... }:

{
  home.packages =
    # Stable packages
    with pkgs; [
      nil # nix language server
      nixfmt-rfc-style # nix formatter
      xdg-utils
      gcc # c compiler
      pyenv
    ]
    # Unstable packages
    ++ (with pkgs.unstable; [
      # essential cli tools
      fastfetch
      wget
      vim
      curl
      unzip
      zip
      ripgrep
      fd

      gemini-cli
      # charm stuff
      gum
      glow
      skate
    ]);
}
