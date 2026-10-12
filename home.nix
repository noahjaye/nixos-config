{ config, pkgs, ...}:

{
  home.username = "noahjaye";
  home.homeDirectory = "/home/noahjaye";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };

  programs.plasma = {
    enable = true;
    workspace.wallpaper = "${config.home.homeDirectory}/wallpapers/delysium.jpg";
    kwin = {
      effects = {
        desktopSwitching.animation = "off";
        #whimsy
        fallApart.enable = true;
        # https://www.youtube.com/watch?v=2X08SW8fok4
        cube.enable = true;
        #endwhimsy
        hideCursor.hideOnTyping = true;
        #whimsy?
        slideBack.enable = true;
        #wobblyWindows.enable = true;
      };
      virtualDesktops = {
        number = 4;
        rows = 2;
        names = [
        "Web"
        "Obs"
        "Cod"
        "Nix"
        ];
      };
    }; 
    #! Set up custom panels soon enough
    spectacle.shortcuts.captureActiveWindow = "Meta+Print";
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

