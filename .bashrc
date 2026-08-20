# Interactive bash. Bash has no ZDOTDIR equivalent, so this must live in $HOME.
# Everything portable is in ~/.config/shell/common, shared with zsh.
[ -f "$HOME/.config/shell/common" ] && . "$HOME/.config/shell/common"
