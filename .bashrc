#
# ~/.bashrc
#

# source ble.sh
# If not running interactively, don't do anything
# [[ $- != *i* ]] && return
# [[ $- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none --rcfile ~/.blerc

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

    source -- /usr/share/git/completion/git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_STATESEPARATOR="|"
    export GIT_PS1_SHOWCOLORHINTS=1
    echo "$(__git_ps1 ' (%s)')"
}

PS1='$(exitstatus) $(current_dir) $(git_info)\n\$ \[\e[1 q\]'

shopt -s checkwinsize
shopt -s autocd

HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "

alias nv="nvim"
export EDITOR="nvim"
export VISUAL=$EDITOR

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -al'
alias grep='grep --color=auto'

# dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# dotlazy
alias dotlazy='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# yazi
function fm() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# edit .zshrc
alias ezshrc='nv $HOME/.zshrc'
# edit .bashrc
alias ebashrc='nv $HOME/.bashrc'

# less
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' -R '

# prevent tmux duplicate entry
if [[ -z $TMUX ]]; then
    # meow
    export PATH="$PATH:$HOME/Projects/meow"
    export PATH="$PATH:$HOME/opt"
fi

source "$HOME/.localbashrc"

# [[ ! ${BLE_VERSION-} ]] || ble-attach
