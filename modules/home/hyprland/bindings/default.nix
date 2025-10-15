{ pkgs, ... }:

{
  imports = [
    ./media.nix
    ./tiling.nix
    ./utilities.nix
  ];

  wayland.windowManager.hyprland = {

    settings = {
      "$mod" = "SUPER"; # Windows key

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod, W, killactive,"
        "$mod, SPACE, exec, $menu"
      ];
    };
  };
}
