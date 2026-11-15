{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.darkman = {
    enable = true;
    settings = {
      lat = 43.3; # go marauders
      lng = -79.9;
    };
    lightModeScripts.plasma = ''
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeLight
    '';
    darkModeScripts.plasma = ''
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark
    '';
  };
}
