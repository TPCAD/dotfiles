#! /bin/bash

OK_COLOR="\033[32m"
ERR_COLOR="\033[31m"
RESET_COLOR="\033[0m"
OK_EMOJI="(/w\)"
ERR_EMOJI="(o_O)"
DIR_COLOR="\033[35m"

exitstatus() {
    if [[ $? == 0 ]]; then
        echo -e "$OK_COLOR$OK_EMOJI$RESET_COLOR"
    else
        echo -e "$ERR_COLOR$ERR_EMOJI$RESET_COLOR"
    fi
}

current_dir() {
    path="${PWD/$HOME/\~}"

    [[ $path == '/' ]] && {
        echo /
        exit 0
    }

    # /etc/dconf/db -> dconf/db >3
    # /etc/dconf -> /etc/dconf ==3
    # /etc -> /etc ==2
    # ~/Blog -> ~/Blog ==2
    # ~/Blog/content -> Blog/content ==3

    IFS='/' read -ra parts <<<"$path"
    if ((${#parts[@]} > 3)); then
        echo -e "$DIR_COLOR${parts[n-2]}$RESET_COLOR/$DIR_COLOR${parts[n-1]}$RESET_COLOR"
    elif ((${#parts[@]} == 3)); then
        [[ ${parts[0]} == '' ]] && printf "/"
        echo -e "$DIR_COLOR${parts[n-2]}$RESET_COLOR/$DIR_COLOR${parts[n-1]}$RESET_COLOR"
    elif ((${#parts[@]} == 2)); then
        [[ ${parts[0]} == '' ]] && echo -e "/$DIR_COLOR${parts[-1]}$RESET_COLOR" || echo -e "$DIR_COLOR${parts[n-2]}$RESET_COLOR/$DIR_COLOR${parts[n-1]}$RESET_COLOR"
    else
        echo -e "$DIR_COLOR${parts[-1]}$RESET_COLOR"
    fi
}

git_info() {
    if ! command -v git >/dev/null 2>&1; then
        echo ""
        return
    fi

    source -- "$HOME/.config/scripts/git-prompt.sh"
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_STATESEPARATOR="|"
    export GIT_PS1_SHOWCOLORHINTS=1
    echo "$(__git_ps1 ' (%s)')"
}

hostname() {
    if [[ -n $SSH_CONNECTION ]]; then
        echo "$HOSTNAME "
    fi
}

PS1='$(hostname)$(exitstatus) $(current_dir) $(git_info)\n\$ \[\e[1 q\]'
