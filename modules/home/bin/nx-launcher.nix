{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules;

  cmd =
    if cfg.walker.enable then
      ''walker --width 644 --maxheight 300 --minheight 300 "$@"''
    else
      "echo 'No launchers configured, check your configuration'";

  content = ''
    exec ${cmd}
  '';
in
pkgs.writeShellScriptBin "nx-launcher" content
