{ config, lib, pkgs, ... } : {
  programs.tmux = {
    enable = true;
    prefix = "M-b";
  };
}
