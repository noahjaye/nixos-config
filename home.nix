{ config, lib, pkgs, ... }:

let
  screen = { w = 1920; h = 1080; panel = 44; };

  half    = screen.w / 2;
  usableH = screen.h - screen.panel;
  left  = { position = "0,0";                  size = "${toString half},${toString usableH}"; };
  right = { position = "${toString half},0";   size = "${toString half},${toString usableH}"; };

  mk = { description, class, title ? null, desktop, geom ? null, maximize ? false }: {
    inherit description;
    match = {
      window-class = { value = class; type = "substring"; };
      window-types = [ "normal" ];
    } // lib.optionalAttrs (title != null) {
      title = { value = title; type = "substring"; };
    };
    apply = {
      desktops = {
        value = desktop;
        apply = "force";
      };
    }
    // lib.optionalAttrs (geom != null) geom
    // lib.optionalAttrs maximize {
      maximizehoriz = true;
      maximizevert = true;
    };
  };

  # this is the very best way to do this, I am sure.
  startLayout = pkgs.writeShellScript "start-layout" ''
    sleep 10
    konsole --profile web-term --title web-term
  '';
#       firefox &
#     obsidian &
#     code &
#     konsole --profile cod-term --title cod-term &
#     konsole --profile nix-term --title nix-term &
#     firefox --no-remote --name firefox-nix --profile "$HOME/.mozilla/firefox-nix" &
in
{
  home.username = "noahjaye";
  home.homeDirectory = "/home/noahjaye";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace.wallpaper = "${config.home.homeDirectory}/wallpapers/delysium.jpg";
    kwin = {
      effects = {
        desktopSwitching.animation = "off";
        #whimsy
        fallApart.enable = false;
        # https://www.youtube.com/watch?v=2X08SW8fok4
        cube.enable = true;
        #endwhimsy
        hideCursor.hideOnTyping = true;
        #whimsy?
        slideBack.enable = false;
        #wobblyWindows.enable = true;
      };
      virtualDesktops = {
        number = 4;
        names = [ "Web" "Obs" "Cod" "Nix" ];
      };
    };
#       window-rules = [
#         {
#           description = "TEST: Konsole on Web";
#
#           match = {
#             window-class = {
#               value = "konsole";
#               type = "substring";
#             };
#             window-types = [ "normal" ];
#           };
#
#           apply = {
#             desktops = {
#               value = "Desktop_1";
#               apply = "force";
#             };
#           };
#         }
#       ];
    window-rules = [
      # Web: terminal left, firefox right
      (mk { description = "Web: terminal"; class = "org.kde.konsole"; title = "web-term"; desktop = "Dekstop_1"; geom = left; })
      (mk { description = "Web: firefox";  class = "firefox"; desktop = "Desktop_1"; geom = right; })

      # Obs: fullscreen obsidian
      (mk { description = "Obs: obsidian"; class = "obsidian"; desktop = "Desktop_2"; maximize = true; })

      # Cod: vscode left, terminal right
      (mk { description = "Cod: vscode";   class = "code"; desktop = "Desktop_3"; geom = left; })
      (mk { description = "Cod: terminal"; class = "org.kde.konsole"; title = "cod-term"; desktop = "Desktop_3"; geom = right; })

      # Nix: terminal left, second firefox right
      (mk { description = "Nix: terminal"; class = "org.kde.konsole"; title = "nix-term"; desktop = "Desktop_4"; geom = left; })
      (mk { description = "Nix: firefox";  class = "firefox-nix"; desktop = "Desktop_4"; geom = right; })
    ];

    #! Set up custom panels soon enough
    spectacle.shortcuts.captureActiveWindow = "Meta+Print";
  };
    # Three Konsole profiles that differ only by tab title. Parent=FALLBACK/
  # inherits everything else (font, colours) from Konsole's defaults.
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

  programs.bash = {
    enable = true;
    shellAliases = {
      #important
      fuck = "echo you";
      hc = "hchc";
      hchw = "history -c && history -w";
      hchc = "history -c && history -w && clear";
      nrs = "snr";
      #radar
      snr = "sudo nixos-rebuild switch";
      #git
      ga = "git add .";
      gs = "git status";
      gl = "git log --oneline";
      gc = "git commit -m";
      gp = "git push";
      #rusty
      cb = "cargo build";
      cr = "cargo run";
      #wlclip
      p = "pwd | wl-copy";
      #flakes
      nf = "nix flake";
      nd = "nix develop";
    };
    initExtra = ''
      source "$(command -v complete_alias)"
      complete -F _complete_alias "''${!BASH_ALIASES[@]}"
      FIGNORE=".lock"
      export NIX_SHELL_PRESERVE_PROMPT=1

      __set_ps1() {
        local br num
        br=$(git branch --show-current 2>/dev/null)
        num='\[\e[0m\]'
        if [ -n "$IN_NIX_SHELL" ]; then
          num='\[\e[38;5;46m\]'
        fi
        PS1='\[\e[95m\]\u\[\e[0m\] \W(\[\e[38;5;33m\]'"$br"'\[\e[0m\]) '"$num"'\!\[\e[0m\]\$ '
      }
      PROMPT_COMMAND=__set_ps1
    '';
  };

  home.packages = with pkgs; [
    bat
    wl-clipboard
    complete-alias
  ];
}
