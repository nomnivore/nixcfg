{
  config,
  pkgs,
  neovim-nightly-overlay,
  lib,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = neovim-nightly-overlay.packages.${pkgs.system}.default;

    vimAlias = true;
    vimdiffAlias = true;
  };

  # fetch my configuration
  # allowing it to update itself (lazy.nvim)
  # and also allow easy local edits

  # FIXME: this may need to be a derivation? not sure how it would work if offline.
  # TODO: dedupe code with 'bootstrap' script
  home.activation.setup-neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.git ]}

    ${builtins.readFile ../bootstrap}
  '';
}
