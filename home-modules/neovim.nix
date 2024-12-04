{
  config,
  pkgs,
  neovim-nightly-overlay,
  lib,
  ...
}:

let
  neovim-pkg = neovim-nightly-overlay.packages.${pkgs.system}.default;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = neovim-pkg;

    vimAlias = true;
    vimdiffAlias = true;
  };

  # fetch my configuration
  # allowing it to update itself (lazy.nvim)
  # and also allow easy local edits

  home.activation.setup-neovim =
    with pkgs;
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH=$PATH:${
        lib.makeBinPath [
          git
          unstable.rustup
          neovim-pkg
        ]
      }

      ${builtins.readFile ../bootstrap}
    '';
}
