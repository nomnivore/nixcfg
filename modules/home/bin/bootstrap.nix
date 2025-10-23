{ pkgs, ... }:

let
  content = builtins.readFile ./bootstrap;
in
pkgs.writeShellScriptBin "bootstrap" content
