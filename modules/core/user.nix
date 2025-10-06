{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];

    # FIXME: add password
    # hashedPassword = "";
    # FIXME: add ssh public key
    # openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];
  };
}
