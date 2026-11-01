{ config, lib, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        shellAliases = import ./shellAliases.nix;
        initExtra = import ./initExtra.nix {inherit lib;};
    };
}
