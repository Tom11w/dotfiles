
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

export PATH="$PATH:$HOME/.rvm/bin"
. "$HOME/.cargo/env"
export SSH_AUTH_SOCK="/var/run/allthenticate-ssh.sock"
