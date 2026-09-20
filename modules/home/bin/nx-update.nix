{
  pkgs,
  vars,
  ...
}:
pkgs.writeShellScriptBin "nx-update" ''
  cd ~/${vars.flakePath}
  git pull
  systemd-inhibit --what=idle --who="nx-update" --why="Updating system" \
    nh os switch
''
