export PATH=~/.bin:~/.toolbox/bin:$PATH
export PATH=/Applications/MacVim.app/Contents/bin/:$PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
export PATH=~/.rvm/bin:$PATH
export PATH="/Applications/Firefox Developer Edition.app/Contents/MacOS":$PATH

alias auth='kinit -f && mwinit -o && ssh-add -D && ssh-add ~/.ssh/id_rsa'
alias auth-ada='ada credentials update --once'
alias bb='brazil-build'
alias bbr='brazil-recursive-cmd --allPackages brazil-build'
alias bc-clear='rm -rf ~/brazil-pkg-cache/*'
alias bc-restart='brazil-package-cache stop; brazil-package-cache start;'
alias ff='open -a "Firefox Developer Edition"'
alias flushdns='sudo killall -HUP mDNSResponder'
alias g='go run'
alias ld='lazydocker'
alias ls='exa'
alias lsl='ls -la --group-directories-first'
alias ls-alias='cat ~/.zshrc | grep -e "^alias"'
alias odin='ssh -f -N -L 2009:localhost:2009 eljust-dev-linux.aka.corp.amazon.com'
alias ssh-al2='ssh eljust-dev-linux.aka.corp.amazon.com'
alias ssh-al2012='ssh dev-dsk-eljust-2a-78d31337.us-west-2.amazon.com'
alias sync='ninja-dev-sync'

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

#
# Syntax Highlighting
#
source /Users/eljust/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
