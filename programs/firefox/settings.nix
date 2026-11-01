{ config, lib, pkgs }:
{
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

      "browser.download.useDownloadDir" = true;
      "browser.download.folderList" = 2;
      "browser.download.dir" = "/home/noahjaye/Downloads/firefox";

      # new way to web
      "ui.key.menuAccessKeyFocuses" = false;

      "extensions.autoDisableScopes" = 0;
}
