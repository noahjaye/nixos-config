# use this mostly to sync terminals to create one mega-terminal for history, including tmux!
{config, lib, pkgs, ...}:
{
    programs.atuin = {
        enable = true;
        daemon.enable = true;
        forceOverwriteSettings = true;
        enableBashIntegration = true;
        settings = {
          filter_mode_shell_up_key_binding = "session-preload";
          inline_height = 10;
          invert = true;
          enter_accept = true;
        };
        flags = [ "--disable-up-arrow" ];

    };
}
