{ config, lib, pkgs, ...}:
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
