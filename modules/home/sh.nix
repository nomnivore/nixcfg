{
  config,
  pkgs,
  vars,
  lib,
  ...
}:

{
  # terminal apps may come from packages.nix, cli-tools.nix, etc.
  # but anything referenced here should be defined here as well
  home.packages = with pkgs.unstable; [
    # cli utils
    lsd
    bat
    jq

  ];

  programs = {
    fzf.enable = true;

    atuin.enable = true;
    zoxide.enable = true;
    # zoxide.config = [ "--cmd cd" ]

    zsh = {
      enable = true;
      enableCompletion = true;

      dotDir = ".config/zsh";

      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
          "zsh-users/zsh-completions"
        ];
      };

      initContent = lib.mkOrder 550 ''
        zstyle ':completion:*' menu select
      '';
    };

    oh-my-posh = {
      enable = true;
      package = pkgs.unstable.oh-my-posh;
      # useTheme = "pure";
      settings = builtins.fromTOML (builtins.readFile ./zsh/omp-pure.toml);
    };
  };

  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/${vars.flakePath}";
    win = "powershell.exe";
    ls = "lsd";
    cat = "bat";
    update-os = "( cd ~/${vars.flakePath} && git pull && nh os switch )";
    nos = "nh os switch";
  };

  home.file.".config/zellij".source = ./zellij;

}
