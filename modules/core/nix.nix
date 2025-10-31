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

      accept-flake-config = true;
      auto-optimise-store = true;
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
