{config, lib, pkgs, ...} : {
  programs.konsole.profiles.nixos = {
    name = "nix-term";
    extraConfig.General.Directory = "/etc/nixos";
  };
}
