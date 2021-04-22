export PATH=/Applications/MacVim.app/Contents/bin/:$PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
export PATH=~/.rvm/bin:$PATH
export PATH="/Applications/Firefox Developer Edition.app/Contents/MacOS":$PATH

alias ff='open -a "Firefox Developer Edition"'
alias flushdns='sudo killall -HUP mDNSResponder'
alias g='go run'
alias ld='lazydocker'
alias ls='exa'
alias lsl='ls -la --group-directories-first'
alias ls-alias='cat ~/.zshrc | grep -e "^alias"'

function findp() {
    find -EL ~/wp -type d -regex ".*/src/$1\$" -mindepth 2 -maxdepth 5 -print 2>/dev/null | cut -d '/' -f 5
}

#
# Starship
#
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

#
# pyenv
#
eval "$(pyenv init -)"

#
# jENV
#
export PATH=~/.jenv/bin:$PATH
eval "$(jenv init -)"
jenv enable-plugin export >> /dev/null
jenv enable-plugin maven >> /dev/null

#
# Nvm
#
export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

#
# Completion 
#
source /Users/eljust/.zsh/completion.zsh
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=~/.zsh_history
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# Initialize the completion system
autoload -Uz compinit

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

#
# Auto suggestion
#
source /Users/eljust/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

#
# Syntax Highlighting
#
source /Users/eljust/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
