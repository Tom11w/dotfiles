#!/bin/sh
set -eu

GITDIR="$HOME/dotfiles"
REPO="git@github.com:Tom11w/dotfiles.git"
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

config() { git --git-dir="$GITDIR" --work-tree="$HOME" "$@"; }

if [ -e "$GITDIR" ]; then
    echo "$GITDIR already exists. Nothing done." >&2
    exit 1
fi

TMP=$(mktemp -d)
git clone --no-checkout --separate-git-dir="$GITDIR" -c core.bare=true -c status.showUntrackedFiles=no "$REPO" "$TMP"
rm -rf "$TMP"

conflicts=$(config ls-tree -r --name-only HEAD | while read -r f; do
    if [ -e "$HOME/$f" ]; then echo "$f"; fi
done)

if [ -n "$conflicts" ]; then
    echo "These files already exist in $HOME and would be overwritten:"
    echo "$conflicts" | sed 's/^/    /'
    echo
    echo "They will be MOVED to $BACKUP (nothing is deleted)."
    # Read from the terminal: stdin is the script itself under `curl | sh`.
    printf 'Continue? [y/N] '
    read -r reply < /dev/tty
    case "$reply" in
        [Yy]*) ;;
        *) echo "Aborted. Remove $GITDIR to start over."; exit 1 ;;
    esac
    echo "$conflicts" | while read -r f; do
        mkdir -p "$BACKUP/$(dirname "$f")"
        mv "$HOME/$f" "$BACKUP/$f"
    done
    echo "Backed up to $BACKUP"
fi

config checkout
