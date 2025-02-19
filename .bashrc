#!/bin/bash

# Set vi mode for bash
set -o vi
bind '"\C-i":complete' # Set auto complete in bash vi mode

# Silence zsh/bash warning on a fucking macOS
export BASH_SILENCE_DEPRECATION_WARNING=1
# Alias to pass TERMINFO to sudo shell for using kitty
alias sudo='sudo TERMINFO="$TERMINFO"'

export GITHUB="$HOME/Desktop/github" # My github space
export NEOVIM_PATH="$HOME/apps/neovim/bin" # neovim installation path
export TMUX_PATH="$HOME/apps/bin" # Tmux installation path
export TMUX_CACHE="${HOME}/.tmuxcache" # Path to tmux console saves
alias tmux-save-pane='tmux capture-pane -pS -'

PATH="$NEOVIM_PATH:$TMUX_PATH:$PATH" # Add to path

# Java env ? 
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
# Customized prompt '>', green as a normal user and red as a sudo user
ascii_green='\[\e[38;5;2m\]'
ascii_red='\[\e[38;5;1m\]'
[ "$EUID" -ne 0 ] && PS1="${ascii_green}>\[\e[0m\] " || PS1="${ascii_red}>\[\e[0m\] "

# list files. 
function lsd() {
    path="$(pwd)"
    # ls -l --color "$@"
    eza -lh "$@"
    printf '\x1b[1;92m%s\x1b[22;0m \n' "$path/"
}

# fuzzy find bash history and execute.
HISTSIZE='' HISTFILESIZE='' # Infinite history.
# fuzzy find bash history and copy to clipboard. 
function fc() {
    history | tail -r | fzf --no-sort | sed 's/ *[0-9]* *//' | tr -d '\n' | pbcopy
}
# fuzzy find bash history and execute.
function fe() {
    eval "$( history | tail -r | fzf --no-sort | sed 's/ *[0-9]* *//' | tr -d '\n' )"
}

# declare with bat
function batdeclare() {
    declare -f "$1" | bat -l sh
}

# bat help
function batman() {
    man "$@" | col -bx | bat -l man 
}

# save tmux panes for the current running session
function savetmuxcache() {

    current_session_name=$(tmux display-message -p '#S')
    current_session_dir="${TMUX_CACHE}/${current_session_name}"
    
    if [ ! -d "$current_session_dir" ]; then
        echo "no tmux cache for the session ${current_session_name} at ${TMUX_CACHE}"
        mkdir -p "$current_session_dir"
        echo "new cache created at : ${current_session_dir}"
        echo "saving logs ... "
    
        list_of_panes=($(tmux list-panes -s | cut -d ':' -f 1))
        
        for pane in "${list_of_panes[@]}"; do
            tmux capture-pane -pet "$pane" -S - > "${current_session_dir}/${pane}.logs"
        done

    fi

}


# Rust or cargo installation. 
. "$HOME/.cargo/env"

# pseudo tty is not allocated for kitty with ssh.
#export TERM=xterm-256color
export PATH="/Users/preeth-raksh/.pixi/bin:$PATH"


# pnpm
export PNPM_HOME="/Users/preeth-raksh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Created by `pipx` on 2024-12-09 14:10:31
export PATH="$PATH:/Users/preeth-raksh/.local/bin"


# nvm - node version manager
export NVM_DIR='/opt/homebrew/Cellar/nvm/0.40.1'
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
