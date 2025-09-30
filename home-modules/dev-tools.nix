{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    # programming languages/toolkits
    # bun is in 'modules'
    nodejs_24
    pnpm
    go
    rustup
    gleam
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
}
