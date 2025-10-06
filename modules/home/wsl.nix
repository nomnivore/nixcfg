{ pkgs, ... }:

{
  home.shellAliases = {
    winhome = "(cd /mnt/c; echo /mnt/c/Users/$(cmd.exe /c \"echo %USERNAME%\" | tr -d \"\r\") )";
    wslsurf = "windsurf --remote wsl+nixos $1";
  };
}
