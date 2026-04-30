{
  pkgs,
  config,
  lib,
  ...
}:
let
  enabled = config.modules.nx.isDesktop;
  isHypr = config.modules.hyprland.enable;

in
if enabled then
  pkgs.writeShellScriptBin "nx-keybinds" ''
    hyprctl binds -j | jq -r '
      def mod_name:
        if . == 0 then ""
        elif . == 1 then "SHF"
        elif . == 8 then "ALT"
        elif . == 64 then "SUP"
        elif . == 65 then "SUP+SHF"
        elif . == 72 then "SUP+ALT"
        elif . == 9 then "ALT+SHF"
        else "MOD_" + tostring
        end;
      def pad(n): . + (" " * ([n - length, 0] | max));
      .[] | select(.modmask != 0) | "\((.modmask | mod_name) | pad(8))\(.key | pad(12)) 󰜴  \(if .description != "" then .description else .dispatcher + (if .arg != "" then " " + .arg else "" end) end)"' | walker -d
  ''
else
  null
