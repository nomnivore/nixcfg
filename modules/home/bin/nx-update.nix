{
  pkgs,
  vars,
  config,
  ...
}:
let
  isDesktop = config.modules.nx.isDesktop;

  switchCmd =
    if isDesktop then
      ''
        systemd-inhibit --what=idle --who="nx-update" --why="Updating system" \
            nh os switch
      ''
    else
      "nh os switch";
in
pkgs.writeShellScriptBin "nx-update" ''
  cd ~/${vars.flakePath}
  git pull
  ${switchCmd}
''
