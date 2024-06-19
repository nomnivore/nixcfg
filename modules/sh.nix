{
  config,
  pkgs,
  vars,
  ...
}:

{
  home.packages = with pkgs.unstable; [ zsh-powerlevel10k ];

  programs = {
    fzf.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      # autosuggestion.enable = true;
      # syntaxHighlighting.enable = true;

      dotDir = ".config/zsh";
      plugins = with pkgs; [
        {
          name = "powerlevel10k.zsh-theme";
          file = "powerlevel10k.zsh-theme";
          src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
        }
        {
          name = "powerlevel10k-config";
          file = ".p10k-pure.zsh";
          src = ./zsh;
        }
      ];
      initExtraBeforeCompInit = builtins.readFile ./zsh/p10k_instant_prompt.zsh;
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
  };

  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/${vars.flakePath}";
    win = "powershell.exe";
    ls = "lsd";
  };
}
