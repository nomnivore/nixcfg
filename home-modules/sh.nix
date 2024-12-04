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

      initExtraBeforeCompInit = ''
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

    # this should be isolated in its own wsl-only module
    # but since WSL is my only machine rn, its ok
    winhome = "(cd /mnt/c; echo /mnt/c/Users/$(cmd.exe /c \"echo %USERNAME%\" | tr -d \"\r\") )";
  };
}
