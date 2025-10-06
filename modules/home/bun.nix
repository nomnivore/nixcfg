{
  config,
  pkgs,
  lib,
  ...
}:
let
  bunOverlay = (
    final: prev: rec {
      version = "1.1.13";
      src =
        passthru.sources.${pkgs.stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${pkgs.stdenvNoCC.hostPlatform.system}");
      passthru = prev.passthru // {
        sources = prev.passthru.sources // {
          "x86_64-linux" = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
            hash = "sha256-QC6dsWjRYiuBIojxPvs8NFMSU6ZbXbZ9Q/+u+45NmPc=";
          };
        };
      };
    }
  );
in
{
  options = {
    lang.bun.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the bun language tooling for Javascript";
    };
    lang.bun.useOverlay = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the bun overlay (good for targeting a newer version than the one in nixpkgs-unstable)";
    };
  };

  config = {
    lang.bun.enable = true;

    # this... works, but no other consumer can reference the overlay (eg: nix-shell)
    home.packages =
      if config.lang.bun.enable then
        if config.lang.bun.useOverlay then
          with pkgs; [ (bun.overrideAttrs bunOverlay) ]
        else
          with pkgs; [ unstable.bun ]
      else
        [ ];
  };
}
