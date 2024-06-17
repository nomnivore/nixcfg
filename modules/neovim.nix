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
  };

  # fetch my configuration
  # allowing it to update itself (lazy.nvim)
  # and also allow easy local edits

  # FIXME: this may need to be a derivation? not sure how it would work if offline.
  # TODO: dedupe code with 'bootstrap' script
  home.activation.setup-neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.git ]}

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
}
