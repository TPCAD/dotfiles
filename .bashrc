#
# ~/.bashrc
#

# source ble.sh
# If not running interactively, don't do anything
# [[ $- != *i* ]] && return
# [[ $- == *i* ]] && source -- /usr/share/blesh/ble.sh --attach=none --rcfile ~/.blerc

if [[ -e "$HOME/.config/scripts/prompt.sh" ]]; then
    source "$HOME/.config/scripts/prompt.sh"
fi

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

# fzf
eval "$(fzf --bash)"

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

if [[ -e "$HOME/.localbashrc" ]]; then
    source "$HOME/.localbashrc"
fi

# [[ ! ${BLE_VERSION-} ]] || ble-attach
