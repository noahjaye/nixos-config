{ config, lib, pkgs, ...}:
let
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
      };
    };
  };
in {
    programs.firefox = {
        enable = true;
        profiles = {
        # bad, probably bite bullet and hand over path
            default = foxCom // { id = 0; isDefault = true; path = "w9xfxn15.default"; };
            cod     = foxCom // { id = 1; };
        };
        policies = {
            ExtensionSettings =
            let
                moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
            in {
                "*" .installation_mode = "blocked";

                "uBlock0@raymondhill.net" = {
                install_url = moz "ublock-origin";
                installation_mode = "force_installed";
                updates_disabled = true;
                };

                "{74145f27-f039-47ce-a470-a662b129930a}" = {
                install_url = moz "clearurls";
                installation_mode = "force_installed";
                updates_disabled = true;
                };
            };

            # Extension configuration
            "3rdparty".Extensions = {
            "uBlock0@raymondhill.net".adminSettings = {
                userSettings = rec {
                uiTheme = "dark";
                uiAccentCustom = true;
                uiAccentCustom0 = "#8300ff";

                importedLists = [
                    "https://filters.adtidy.org/extension/ublock/filters/3.txt"
                    "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                ];

                externalLists = lib.concatStringsSep "\n" importedLists;
                };

                selectedFilterLists = [
                "CZE-0"
                "adguard-generic"
                "adguard-annoyance"
                "adguard-social"
                "adguard-spyware-url"
                "easylist"
                "easyprivacy"
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                "plowe-0"
                "ublock-abuse"
                "ublock-badware"
                "ublock-filters"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                "urlhaus-1"
                "userFilters"
                ];
                userFilters = ''
                www.youtube.com##ytd-rich-section-renderer:has(ytd-rich-shelf-renderer[is-shorts])
                www.youtube.com##ytd-reel-shelf-renderer
                www.youtube.com##ytd-video-renderer:has(a[href^="/shorts/"])
                www.youtube.com##ytd-guide-entry-renderer:has(a[title="Shorts"])
                www.youtube.com##ytd-mini-guide-entry-renderer[aria-label="Shorts"]
                ||youtube.com/shorts/$document
                '';
            };
            };
        };
    };
}
