{
  pkgs,
  config,
  lib,
  ...
}:
let
  enabled =
    config.modules.nx.isDesktop && config.modules.hyprland.enable && config.modules.walker.enable;
in
if enabled then
  pkgs.writeShellScriptBin "nx-power-menu" ''
    MENU_OPTIONS="  Lock
      Logout
      Sleep
      Reboot
      Shutdown"

    #TODO: add a lock service
    LOCK_CMD="hyprctl dispatch exit"
    LOGOUT_CMD="hyprctl dispatch exit"
    SLEEP_CMD="systemctl suspend"
    REBOOT_CMD="systemctl reboot"
    SHUTDOWN_CMD="systemctl poweroff"

    # start the menu
    CHOICE=$(echo -e "$MENU_OPTIONS" | walker -d)

    # check if a choice was made
    if [[ -z "$CHOICE" ]]; then
      exit 0
    fi

    case "$CHOICE" in
      *Lock*) $LOCK_CMD ;;
      *Logout*) $LOGOUT_CMD ;;
      *Sleep*) $SLEEP_CMD ;;
      *Reboot*) $REBOOT_CMD ;;
      *Shutdown*) $SHUTDOWN_CMD ;;
    esac
  ''
else
  null
