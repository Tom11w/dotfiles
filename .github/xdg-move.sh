#!/bin/sh
# Moves tools' folders out of $HOME into the XDG directories. ~/.config/shell/common points
# each tool at its new folder once that folder exists, so a machine switches tool by tool as
# this script moves them. Safe to re-run: a folder that is already moved, or whose tool is
# not installed, is skipped. Run it with the tools closed, then open new shells (running
# shells keep the old paths).
set -eu
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

move() {
    from=$1 to=$2
    [ -e "$from" ] || return 0
    if [ -e "$to" ]; then
        echo "skipped  $from: $to already exists, merge by hand"
        return 0
    fi
    mkdir -p "$(dirname "$to")"
    mv "$from" "$to"
    echo "moved    $from -> $to"
}

move "$HOME/.cargo"          "$XDG_DATA_HOME/cargo"
move "$HOME/.rustup"         "$XDG_DATA_HOME/rustup"
move "$HOME/.nvm"            "$XDG_DATA_HOME/nvm"
move "$HOME/.oh-my-zsh"      "$XDG_DATA_HOME/oh-my-zsh"
move "$HOME/.npm"            "$XDG_CACHE_HOME/npm"
move "$HOME/.gem/ruby"       "$XDG_DATA_HOME/gem/ruby"
move "$HOME/.gem/specs"      "$XDG_CACHE_HOME/gem/specs"
if [ -d "$HOME/.gem" ]; then rmdir "$HOME/.gem" && echo "removed  $HOME/.gem (empty)"; fi
move "$HOME/.python_history" "$XDG_STATE_HOME/python/history"
move "$XDG_STATE_HOME/python_history" "$XDG_STATE_HOME/python/history"   # an earlier layout
move "$HOME/.ipython"        "$XDG_CONFIG_HOME/ipython"
move "$HOME/.jupyter"        "$XDG_CONFIG_HOME/jupyter"
move "$HOME/.matplotlib"     "$XDG_CONFIG_HOME/matplotlib"
move "$HOME/.ansible"        "$XDG_DATA_HOME/ansible"
# DOTNET_CLI_HOME is a stand-in $HOME for dotnet: it keeps .dotnet and .templateengine inside
move "$HOME/.dotnet"         "$XDG_DATA_HOME/dotnet/.dotnet"
move "$HOME/.templateengine" "$XDG_DATA_HOME/dotnet/.templateengine"
move "$HOME/.nuget/packages" "$XDG_CACHE_HOME/NuGetPackages"
move "$HOME/.boto"           "$XDG_CONFIG_HOME/gcloud/boto"
move "$HOME/.jenv"           "$XDG_DATA_HOME/jenv"
# then set Android Studio's Gradle user home to the same folder
move "$HOME/.gradle"         "$XDG_DATA_HOME/gradle"
move "$HOME/.terminfo"       "$XDG_DATA_HOME/terminfo"
move "$HOME/.wget-hsts"      "$XDG_DATA_HOME/wget-hsts"
move "$HOME/.bash_history"   "$XDG_STATE_HOME/bash/history"
move "$HOME/.lesshst"        "$XDG_STATE_HOME/less/history"
move "$XDG_STATE_HOME/lesshst" "$XDG_STATE_HOME/less/history"   # less's own XDG default
move "$HOME/.node_repl_history" "$XDG_STATE_HOME/node/repl_history"
# brew reads its tap trust list from here as soon as XDG_CONFIG_HOME is set
move "$HOME/.homebrew/trust.json" "$XDG_CONFIG_HOME/homebrew/trust.json"
rm -f "$HOME/.homebrew/trust.json.lock"
if [ -d "$HOME/.homebrew" ]; then rmdir "$HOME/.homebrew" && echo "removed  $HOME/.homebrew (empty)"; fi

# history folders the shell config points at; the tools write into them but don't create them
for d in bash python node less; do mkdir -p "$XDG_STATE_HOME/$d"; done
