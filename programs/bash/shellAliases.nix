{
  #important
  fuck = "echo you";
  nrs = "snr";
  zoom = " powerprofilesctl launch --profile performance --reason \"generic and unknowable speed\" ";
  ncg = "zoom sudo nix-collect-garbage";
  #radar
  snr = "zoom sudo nixos-rebuild switch";
  #git
  ga = "git add .";
  gs = "git status -s";
  gss = "git status";
  gl = "git log --oneline";
  gll = "git log";
  gc = "git commit -m";
  gp = "git push";
  gwi = "git switch";
  gso = "git show";
  gd = "git diff";
  gds = "git diff --staged";
  #rusty
  cb = "zoom cargo build";
  cr = "zoom cargo run";
  cbr = "zoom cargo build --release";
  #wlclip
  p = "pwd | wl-copy";
  pp = ''cd "$(wp)"'';
  #flakes
  nf = "nix flake";
  nd = "nix develop";
  # code
  c = "code -r .";
  # copy
  wc = "wl-copy";
  wp = "wl-paste";
  # grep
  grn = "grep -rn";
  grni = "grep -rnI";
  # snow
  snow = "shutdown now";
  sres = "reboot";
  sus = "systemctl suspend";
}
