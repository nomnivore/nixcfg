# ! NOT A COMPLETE HOST ! #
{
  pkgs,
  hostname,
  username,
  ...
}:

{
  imports = [
    ../modules/core
  ];
  time.timeZone = "America/Detroit";
  networking.hostName = "${hostname}";

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;
}
