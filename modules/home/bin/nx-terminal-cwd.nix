# source: https://github.com/basecamp/omarchy/blob/master/bin/omarchy-cmd-terminal-cwd
{
  pkgs,
  config,
  lib,
  ...
}:
let
  isHypr = config.modules.hyprland.enable;
in
pkgs.writeShellScriptBin "nx-terminal-cwd" ''
  terminal_pid=$(hyprctl activewindow | awk '/pid:/ {print $2}')
  shell_pid=$(pgrep -P "$terminal_pid" | tail -n1)

  if [[ -n $shell_pid ]]; then
    cwd=$(readlink -f "/proc/$shell_pid/cwd" 2>/dev/null)
    if [[ -n $cwd ]]; then
      echo "$cwd"
    else
      echo "$HOME"
    fi
  else
    echo "$HOME"
  fi
''
