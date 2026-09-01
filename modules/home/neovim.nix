{
  config,
  pkgs,
  neovim-nightly-overlay,
  lib,
  ...
}:

let
  neovim-pkg = neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # not using the home-manager `programs.neovim` module: it insists on
  # managing ~/.config/nvim/init.lua itself, which collides with the
  # out-of-store symlink below (my nvim config is a separate git repo)
  home.packages = [ neovim-pkg ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    n = "nvim";
    vim = "nvim";
    vi = "nvim";
    vimdiff = "nvim -d";
  };

  # fetch my configuration
  # allowing it to update itself (lazy.nvim)
  # and also allow easy local edits
  #
  modules.extRepos.nvim = {
    repo = "nomnivore/nvim";
    links = {
      ".config/nvim" = ".";
    };
  };

  # home.activation.setup-neovim =
  #   with pkgs;
  #   lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     PATH=$PATH:${
  #       lib.makeBinPath [
  #         git
  #         unstable.rustup
  #         neovim-pkg
  #       ]
  #     }
  #
  #     ${builtins.readFile ../bootstrap}
  #   '';
}
