# ~/.zshrc — shared personal config (tracked in dotfiles, portable across machines).
# Machine-specific / corporate / secret settings live in ~/.zshrc.local
# (untracked), which is sourced at the very end if present.

# --- XDG -------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"

# --- Homebrew (early, so brew tools are on PATH) ---------------------------
eval "$([ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv)"

# --- PATH (personal) -------------------------------------------------------
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/go/bin:$PATH"       # GOPATH bin (go install targets)
export PATH="$HOME/.local/bin:$PATH"

# --- History ---------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# --- Completions -----------------------------------------------------------
autoload -Uz compinit
compinit

# --- Autosuggestions -------------------------------------------------------
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# --- Starship prompt -------------------------------------------------------
eval "$(starship init zsh)"

# --- nvm -------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

# --- Rust (if installed) ---------------------------------------------------
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --- Aliases (general) -----------------------------------------------------
alias h="herdr"
alias ls="eza"
alias lsl="ls -la --group-directories-first"
alias ld="lazydocker"
alias lg="lazygit"
alias n="nvim"
alias oc="opencode"
alias zz="nvim ~/.zshrc"
alias cidgen="uuidgen | tr 'A-Z' 'a-z' | sed 's/-//g'"

# tmux
alias tmn="tmux new-session -s"
alias tml="tmux list-sessions"
alias tma="tmux attach-session -t"
alias tmk="tmux kill-session -t"

# misc
alias jl="jupyter lab"
alias zj="zellij --layout dev"

# --- Functions (general) ---------------------------------------------------
# Show processes using the most file descriptors
openfiles() {
    for pid in $(lsof | awk '{print $2}' | sort | uniq -c | sort -rn | head | awk '{print $2}'); do
        count=$(lsof | awk '{print $2}' | grep -c "^${pid}$")
        name=$(ps -p $pid -o comm= 2>/dev/null || echo "not running")
        printf "%5d files: %-20s (PID %s)\n" $count "$name" $pid
    done
}

# List custom make targets (those not from the Go boilerplate)
ls-make() {
    make -pRrq : 2>/dev/null | awk '/^[a-zA-Z0-9][^$#%\/\t=]*:([^=]|$)/{target=$1; sub(/:$/,"",target); pending=target} /commands to execute/{if(length(pending)>0 && index($0,"go.mk")==0) print pending; pending=""} /^$/{pending=""}' | sort -u;
}

# --- Machine-specific / corporate overlay (untracked) ----------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
