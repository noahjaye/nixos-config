{ config, lib, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        shellAliases = {
        #important
        fuck = "echo you";
        hc = "hchc";
        hchw = "history -r && history -a /home/noahjaye/myhis.txt && history -c";
        hchc = "hchw && clear";
        nrs = "snr";
        zoom = " powerprofilesctl launch --profile performance --reason \"generic and unknowable speed\" ";
        ncg = "zoom sudo nix-collect-garbage";
        #radar
        snr = "zoom sudo nixos-rebuild switch";
        #git
        ga = "git add .";
        gs = "git status";
        gl = "git log --oneline";
        gc = "git commit -m";
        gp = "git push";
        gwi = "git switch";
        #rusty
        cb = "cargo build";
        cr = "cargo run";
        #wlclip
        p = "pwd | wl-copy";
        #flakes
        nf = "nix flake";
        nd = "nix develop";
        # code
        c = "code -r .";
        };
        initExtra = ''
        source "$(command -v complete_alias)"
        complete -F _complete_alias "''${!BASH_ALIASES[@]}"
        FIGNORE=".lock"
        export NIX_SHELL_PRESERVE_PROMPT=1
        __set_ps1() {
            local br status num brcolor idx dname p count parts
            br=$(git branch --show-current 2>/dev/null)
            brcolor='\[\e[38;5;33m\]'
            if [ -n "$br" ]; then
                status=$(git status --short 2>/dev/null)
                if [ -n "$status" ]; then
                    if grep -q '^.[^ ]' <<< "$status"; then
                        brcolor='\[\e[31m\]'
                    else
                        brcolor='\[\e[32m\]'
                    fi
                fi
            fi
            num='\[\e[0m\]'
            if [ -n "$IN_NIX_SHELL" ]; then
                num='\[\e[38;5;105m\]'
            fi

            # index the current dir name if it repeats earlier in the path
            idx=""
            dname=''${PWD##*/}
            if [ "$PWD" != "$HOME" ] && [ -n "$dname" ]; then
                count=0
                IFS=/ read -ra parts <<< "$PWD"
                for p in "''${parts[@]}"; do
                    [ "$p" = "$dname" ] && count=$((count + 1))
                done
                if [ "$count" -gt 1 ]; then
                    idx='\[\e[90m\]:'"$count"'\[\e[0m\]'
                fi
            fi

            PS1='\[\e[95m\]\u\[\e[0m\] \W'"$idx"'('"$brcolor""$br"'\[\e[0m\]) '"$num"'\!\[\e[0m\]\$ '
        }
        PROMPT_COMMAND=__set_ps1
        '';
    };
}
