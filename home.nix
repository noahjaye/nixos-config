{ config, lib, pkgs, ... }:

let
dir = ./programs;
  entries = builtins.readDir dir;

  files = builtins.filter
    (name:
      entries.${name} == "regular"
      && builtins.match ".*\\.nix" name != null
      && name != "default.nix")
    (builtins.attrNames entries);

in {
  home.username = "noahjaye";
  home.homeDirectory = "/home/noahjaye";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };
  imports = map (name: dir + "/${name}") files;

  home.packages = with pkgs; [
    bat
    wl-clipboard
    complete-alias
    (writeShellApplication {
      name = "catc";
      runtimeInputs = [ coreutils wl-clipboard ];
      text = ''
        cat "$@" | wl-copy
      '';
    })
    (writeShellApplication {
      name = "denv";
      text = ''
        echo "use flake" > .envrc && direnv allow;
      '';
    })
  ];
}
