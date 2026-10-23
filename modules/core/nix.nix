{
  pkgs,
  inputs,
  username,
  ...
}:

{
  nix = {
    settings = {
      trusted-users = [ username ];
      # FIXME: access tokens for github and gitlab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      auto-optimise-store = true;

      # binary caches (system-wide, not just via flake nixConfig)
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://statix.cachix.org"
        "https://walker.cachix.org"
        "https://walker-git.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "statix.cachix.org-1:Z9E/g1YjCjU117QOOt07OjhljCoRZddiAm4VVESvais="
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
        "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      ];
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
      nixpkgs-unstable = {
        flake = inputs.nixpkgs-unstable;
      };
    };

    nixPath = [
      # prefer 'unstable' for nix-shell etc
      "nixpkgs=${inputs.nixpkgs-unstable.outPath}"
      # FIXME: the overlays-compat trick doesn't work at all for me.
      "nixpkgs-overlays=${toString ../../overlays-compat}"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      options = "--delete-older-than 14d";
    };
  };
}
