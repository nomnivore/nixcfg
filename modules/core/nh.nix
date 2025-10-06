{
  pkgs,
  username,
  vars,
  ...
}:

{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/${vars.flakePath}";
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  # disabled due to 'nh.clean.enable'
  nix.gc.automatic = false;

}
