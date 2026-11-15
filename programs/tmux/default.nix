{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    prefix = "M-b";
    extraConfig = ''
      bind C-i select-pane -t '{top-left}'
      bind C-o select-pane -t '{top-right}'
      bind C-j select-pane -t '{bottom-left}'
      bind C-k select-pane -t '{bottom-right}'
    '';
  };
}
