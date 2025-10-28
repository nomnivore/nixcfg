{
  pkgs,
  config,
  lib,
  ...
}:
let
  enabled = config.modules.nx.isDesktop;
  pkg = pkgs.unstable.chromium;
in
# only write the script if we are in a desktop environment
if enabled then
  pkgs.writeShellApplication {
    name = "nx-launch-webapp";
    runtimeInputs = [ pkg ];
    text = ''
      exec setsid uwsm-app -- ${lib.getExe pkg} --app="$1" "$\{@:2}"
    '';
  }
else
  null
