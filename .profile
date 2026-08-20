# Login shells for sh/bash. There's no .bash_profile, so bash login reads this.
# Interactive bash gets everything through .bashrc; other shells need it direct.
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
else
    [ -f "$HOME/.config/shell/common" ] && . "$HOME/.config/shell/common"
fi
