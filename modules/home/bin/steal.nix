{ pkgs, ... }:

let
  content = builtins.readFile ./steal;
in
pkgs.writeShellScriptBin "steal" content
