{lib}:
lib.mkAfter ''
    source "$(command -v complete_alias)"
    complete -F _complete_alias "''${!BASH_ALIASES[@]}"
    FIGNORE=".lock:.o:.direnv"
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
    PROMPT_COMMAND="__set_ps1''${PROMPT_COMMAND:+;$PROMPT_COMMAND}"


    #Eventually move this to a real system so programs controls all initExtra related to them
    atuin-bind '\e[6~' atuin-search

    __atuin_big() {
        local -x ATUIN_INLINE_HEIGHT=40
        __atuin_history
        }
    atuin-bind '\e[5~' __atuin_big
    ''
