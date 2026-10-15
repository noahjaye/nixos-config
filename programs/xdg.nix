{config, lib, pkgs, ...}:

let
# this is the very best way to do this, I am sure.
   startLayout = pkgs.writeShellScript "start-layout" ''
   sudo powerprofilesctl launch --profile performance --reason "ts startup was so slow"
    konsole --profile web-term --title web-term &
     firefox --new-window &
    MOZ_APP_REMOTINGNAME=fx-cod firefox --new-instance -P cod \
      --name fx-cod --class fx-cod --new-window &
    obsidian &
    code &
    konsole --profile cod-term --title cod-term --workdir /home/noahjaye/projects --hide-menubar --hide-tabbar &
    konsole --profile nix-term --title nix-term --workdir /etc/nixos &
    kate /etc/nixos/flake.nix /etc/nixos/configuration.nix /etc/nixos/home.nix

    powerprofilesctl set power-saver
  '';
in {
  xdg.dataFile = lib.listToAttrs (map (n:
  lib.nameValuePair "konsole/${n}.profile" {
    text = ''
      [General]
      Name=${n}
      Parent=FALLBACK/
      LocalTabTitleFormat=${n}
      RemoteTabTitleFormat=${n}
    '';
  }) [ "web-term" "cod-term" "nix-term" ]);

  xdg.configFile."autostart/window-layout.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Window layout
    Exec=${startLayout}
  '';
}
