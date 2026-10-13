{ config, lib, pkgs, ... }:

let
  screen = { w = 1920; h = 1080; panel = 44; };

  half    = screen.w / 2;
  usableH = screen.h - screen.panel;
  halfH   = usableH / 2;

    region = x: y: w: h: {
    position = "${toString x},${toString y}";
    size     = "${toString w},${toString h}";
  };

   left  = region 0    0 half usableH;
  right = region half 0 half usableH;

  topLeft     = region 0    0     half halfH;
  topRight    = region half 0     half halfH;
  bottomLeft  = region 0    halfH half (usableH - halfH);
  bottomRight = region half halfH half (usableH - halfH);

  mk = { description, class, classType ? "substring", title ? null, desktop, geom ? null, maximize ? false, force ? false }: {
    inherit description;
    match = {
      window-class = { value = class; type = classType; };
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
    // lib.optionalAttrs (geom != null) (
      lib.mapAttrs (_: v: {
        value = v;
        apply = if force then "force" else "initially";
      }) geom
    )
    // lib.optionalAttrs maximize {
      maximizehoriz = true;
      maximizevert = true;
    };
  };

  # this is the very best way to do this, I am sure.
   startLayout = pkgs.writeShellScript "start-layout" ''
    sleep 3
    konsole --profile web-term --title web-term &
     firefox --new-window &
    MOZ_APP_REMOTINGNAME=fx-cod firefox --new-instance -P cod \
      --name fx-cod --class fx-cod --new-window &
    obsidian &
    code &
    konsole --profile cod-term --title cod-term &
    konsole --profile nix-term --title nix-term --workdir /etc/nixos &
    kate /etc/nixos/flake.nix /etc/nixos/configuration.nix /etc/nixos/home.nix
  '';
  foxCom = {
    settings = {
      # startup
      "browser.startup.page" = 3;
      "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
      "browser.newtabpage.enabled" = false;
      "browser.tabs.insertAfterCurrent" = true;

      # UI
      "browser.toolbars.bookmarks.visibility" = "never";
      "sidebar.visibility" = "hide-launcher";

      # privacy
      "privacy.resistFingerprinting" = true;
      "privacy.clearOnShutdown_v2.formdata" = true;

      # urlbarsearch
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "browser.urlbar.suggest.bookmark" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.quickactions" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.topsites" = false;

      # NOAI/misc
      "browser.ai.control.default" = "blocked";
      "browser.ai.control.linkPreviewKeyPoints" = "blocked";
      "browser.ai.control.pdfjsAltText" = "blocked";
      "browser.ai.control.sidebarChatbot" = "blocked";
      "browser.ai.control.smartTabGroups" = "blocked";
      "browser.ai.control.smartWindow" = "blocked";
      "browser.ai.control.translations" = "blocked";
      "browser.ml.chat.enabled" = false;
      "browser.ml.chat.page" = false;
      "browser.ml.linkPreview.enabled" = false;
      "browser.tabs.groups.smart.enabled" = false;
      "browser.tabs.groups.smart.userEnabled" = false;
      "browser.translations.enable" = false;
      "browser.smartwindow.memories.generateFromConversation" = false;
      "browser.smartwindow.memories.generateFromHistory" = false;
      "extensions.ml.enabled" = false;
      "pdfjs.enableAltText" = false;
    };

    search = {
      force = true;
      default = "ddg";
      # thank you https://nix-community.github.io/home-manager/options/home-manager/programs/firefox.html
      engines = {
        nix-packages = {
          name = "Nix Packages";
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        nixos-wiki = {
          name = "NixOS Wiki";
          urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
          iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
          definedAliases = [ "@nw" ];
        };
      };
    };
  };
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
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
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
      (mk { description = "Web: terminal"; class = "org.kde.konsole"; title = "web-term"; desktop = "Desktop_1"; geom = left; })
      (mk { description = "Web: firefox"; class = "^(?!.*fx-cod).*firefox"; classType = "regex"; desktop = "Desktop_1"; geom = right; force = true; })

      # Obs: fullscreen obsidian
      (mk { description = "Obs: obsidian"; class = "obsidian"; desktop = "Desktop_2"; maximize = true; })

      # Cod: vscode left, terminal bottom right, firefox top right
      (mk { description = "Cod: vscode";   class = "code"; desktop = "Desktop_3"; geom = left; })
      (mk { description = "Cod: terminal"; class = "org.kde.konsole"; title = "cod-term"; desktop = "Desktop_3"; geom = bottomRight; })
        (mk { description = "Cod: firefox"; class = "fx-cod"; desktop = "Desktop_3"; geom = topRight; force = true; })

      # Nix: terminal left, second firefox right (fix second firefox!)
      (mk { description = "Nix: terminal"; class = "org.kde.konsole"; title = "nix-term"; desktop = "Desktop_4"; geom = left; })
      (mk { description = "Nix: kate"; class = "org.kde.kate"; desktop = "Desktop_4"; geom = right; })
    ];

    #is this a reasonable use of alt?
    shortcuts.kwin = {
      "Switch to Desktop 1" = "Alt+A";
      "Switch to Desktop 2" = "Alt+S";
      "Switch to Desktop 3" = "Alt+D";
      "Switch to Desktop 4" = "Alt+F";
    };
    hotkeys.commands."konsole-nixos" = {
      name = "Konsole in /etc/nixos";
      key = "Meta+Shift+N";
      command = "konsole --workdir /etc/nixos";
    };
    input.keyboard.options = ["ctrl:ralt_rctrl"];
    #! Set up custom panels soon enough
    spectacle.shortcuts.captureActiveWindow = "Meta+Print";
  };
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
  programs.konsole.profiles.nixos = {
    name = "nix-term";
    extraConfig.General.Directory = "/etc/nixos";
  };
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
      snr = "powerprofilesctl launch --profile performance nixos-rebuild switch --sudo";
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
        local br status num brcolor
        br=$(git branch --show-current 2>/dev/null)
        brcolor='\[\e[38;5;33m\]'
        if [ -n "$br" ]; then
          status=$(git status --short 2>/dev/null)
          if [ -n "$status" ]; then
            if grep -q '^.[^ ]' <<< "$status"; then
              brcolor='\[\e[31m\]'
            else
              brcolor='\[\e[32m\]'
            fi
          fi
        fi
        num='\[\e[0m\]'
        if [ -n "$IN_NIX_SHELL" ]; then
          num='\[\e[38;5;46m\]'
        fi
        PS1='\[\e[95m\]\u\[\e[0m\] \W('"$brcolor""$br"'\[\e[0m\]) '"$num"'\!\[\e[0m\]\$ '
      }
      PROMPT_COMMAND=__set_ps1
    '';
  };
  programs.firefox = {
    enable = true;
      profiles = {
        default = foxCom // { id = 0; isDefault = true; path = "w9xfxn15.default"; };
        cod     = foxCom // { id = 1; };
      };
  };
  home.packages = with pkgs; [
    bat
    wl-clipboard
    complete-alias
  ];
}
