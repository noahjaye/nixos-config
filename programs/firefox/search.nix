{config, lib, pkgs, ...}:
{
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
    nixos-options = {
      name = "NixOS Options";
      urls = [{
        template = "https://search.nixos.org/options";
        params = [
          { name = "type"; value = "options"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@no" ];
    };
    nixos-flakes = {
      name = "NixOS Flakes";
      urls = [{
        template = "https://search.nixos.org/flakes";
        params = [
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@nf" ];
    };
    home-manager-opts = {
      name = "Home Manager Options";
      urls = [{
        template = "https://home-manager-options.extranix.com/";
        params = [
          { name = "type"; value = "flakes"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@hm" ];
    };
    tidal = {
      name = "Tidal";
      urls = [{
        template = "https://tidal.com/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
        ];
      }];

#           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@ti" ];
    };
    wookiepedia = {
      name = "Wookiepedia";
      urls = [{
        template = "https://starwars.fandom.com/wiki/Special:Search";
        params = [
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

#           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@wo" ];
    };
    obsidian = {
      name = "Obsidian";
      urls = [{
        template = "https://community.obsidian.md/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
        ];
      }];

#           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@ob" ];
    };
    arch = {
      name = "arch";
      urls = [{
        template = "https://man.archlinux.org/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
        ];
      }];

#           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@ar" ];
    };
    rust = {
      name = "Rust Crates";
      urls = [{
        template = "https://docs.rs/releases/search";
        params = [
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

#           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@rs" ];
    };
  };
}
