{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "noahjaye";
      user.email = "noahjaye@gmail.com";
      init.defaultBranch = "main";
    };
  };
}
