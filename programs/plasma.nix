{config, lib, pkgs, ...} :
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

  # I am lazy
  split = usableH * 2 / 3;

  topLeft     = region 0    0      half halfH;
  topRight    = region half 0      half split;
  bottomLeft  = region 0    halfH  half (usableH - halfH);
  bottomRight = region half split half (usableH - split);

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


in {
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
      (mk { description = "Web: firefox"; class = "^(?!.*fx-cod).*firefox"; classType = "regex"; desktop = "Desktop_1"; geom = right;})# force = true; })

      # Obs: fullscreen obsidian
      (mk { description = "Obs: obsidian"; class = "obsidian"; desktop = "Desktop_2"; maximize = true; })

      # Cod: vscode left, terminal bottom right, firefox top right
      (mk { description = "Cod: vscode";   class = "code"; desktop = "Desktop_3"; geom = left; })
      (mk { description = "Cod: terminal"; class = "org.kde.konsole"; title = "cod-term"; desktop = "Desktop_3"; geom = bottomRight; })
        (mk { description = "Cod: firefox"; class = "fx-cod"; desktop = "Desktop_3"; geom = topRight; })#force = true; })

      # Nix: terminal left, second firefox right (fix second firefox!)
      (mk { description = "Nix: terminal"; class = "org.kde.konsole"; title = "nix-term"; desktop = "Desktop_4"; geom = left; force = true; })
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

}
