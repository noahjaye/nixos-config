# use this mostly to sync terminals to create one mega-terminal for history, including tmux!
{config, lib, pkgs, ...}:
{
    programs.atuin = {
        enable = true;
        daemon.enable = true;
        forceOverwriteSettings = true;
        enableBashIntegration = true;
    };
}
