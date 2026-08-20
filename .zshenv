# zsh reads this from $HOME before anything else, and it is the only place
# ZDOTDIR can be set. Everything else lives in ~/.config/zsh.
export ZDOTDIR="$HOME/.config/zsh"
[ -f "$ZDOTDIR/.zshenv" ] && . "$ZDOTDIR/.zshenv"
