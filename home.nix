{
  config,
  lib,
  pkgs,
  ...
}:

let
  dir = ./programs;
  entries = builtins.readDir dir;

  files = builtins.filter (
    name:
    (entries.${name} == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    || (entries.${name} == "directory" && builtins.pathExists (dir + "/${name}/default.nix"))
  ) (builtins.attrNames entries);
in
{
  home.username = "noahjaye";
  home.homeDirectory = "/home/noahjaye";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = 1;
    _ZO_EXCLUDE_DIRS = "$HOME:/nix/store/*";
  };
  imports = map (name: dir + "/${name}") files;

  home.packages = with pkgs; [
    bat
    wl-clipboard
    complete-alias
    comic-mono
    gcc
    nixfmt
    perf
    # the new age
    uv
    hexyl
    xxd
    ripgrep
    fd
    (writeShellApplication {
      name = "catc";
      runtimeInputs = [
        coreutils
        wl-clipboard
      ];
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
    (writeShellApplication {
      name = "isli";
      text = ''
        test -L "$@" && echo y || echo n;
      '';
    })
    (writeShellApplication {
      name = "gitscan";
      text = builtins.readFile ./programs/scripts/gitscan.sh;
    })

  ];
}
