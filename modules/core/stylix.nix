{ pkgs, ... }:

{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  environment.systemPackages = with pkgs; [
    nerd-fonts.monaspace
    monaspace # fallback?
  ];

  stylix.fonts = {
    # serif = {};
    # sansSerif = {};
    monospace = {
      package = pkgs.nerd-fonts.monaspace;
      name = "MonaspiceNe Nerd Font";
    };
    # emoji = {};
  };
}
