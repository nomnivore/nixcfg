{
  config,
  pkgs,
  vars,
  ...
}:

{
  # terminal apps may come from home.nix
  # but anything referenced here should be defined here as well
  home.packages = with pkgs.unstable; [
    lsd
    bat
  ];

  programs = {
    fzf.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;

      dotDir = ".config/zsh";

      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          "agkozak/z"
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
          "zsh-users/zsh-completions"
        ];
      };
      # oh-my-zsh = {
      #   enable = true;
      #   plugins = [ "z" ];
      #   extraConfig = ''
      #     zstyle ':completion:*' menu select
      #   '';
      # };
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
    _ls = "ls";
    ls = "lsd";
    _cat = "cat";
    cat = "bat";
  };
}
