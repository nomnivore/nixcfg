{ pkgs, ... }:

let
  content = builtins.readFile ./clean-runner-caches;
in
pkgs.writeShellScriptBin "clean-runner-caches" content
