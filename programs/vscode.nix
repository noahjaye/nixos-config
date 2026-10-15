{ config, lib, pkgs, ... } : {
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "clang-format.executable" = "clang-format";
      "git.blame.editorDecoration.enabled" = true;
      "chat.disableAIFeatures" = true;
    };
  };
}
