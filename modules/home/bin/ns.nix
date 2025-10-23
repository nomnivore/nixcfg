{ pkgs, ... }:

let
  content = builtins.readFile ./ns;
in
pkgs.writeShellScriptBin "ns" content
