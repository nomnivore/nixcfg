{ config, pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      dotDir = ".config/zsh";
      plugins = with pkgs; [
        {
          name = "powerlevel10k.zsh-theme";
          file = "powerlevel10k.zsh-theme";
          src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
        }
        {
          name = "powerlevel10k-config";
          file = ".p10k.zsh";
          src = ./zsh;
        }
      ];
      initExtraBeforeCompInit = builtins.readFile ./zsh/p10k_instant_prompt.zsh;
      oh-my-zsh = {
        enable = true;
        plugins = [ "z" ];
        extraConfig = ''
          zstyle ':completion:*' menu select
        '';
      };
    };
  };

  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixcfg";
    win = "powershell.exe";
    ls = "lsd";
  };
}
