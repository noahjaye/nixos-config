{ config, lib, pkgs, ... } : {
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "clang-format.executable" = "clang-format";
      "git.blame.editorDecoration.enabled" = true;
      "chat.disableAIFeatures" = true;
      "editor.fontFamily" = "Comic Mono, monospace";
      "editor.fontSize" = 14;
    };
  };
}
