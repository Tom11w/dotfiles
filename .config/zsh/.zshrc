# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"   # common sets it once moved to the XDG data dir

# ---- everything below must be set before oh-my-zsh is sourced ----

# History and the completion dump are state, not config. Without these,
# /etc/zshrc puts them in $ZDOTDIR.
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}
[[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

# fpath additions, because oh-my-zsh runs compinit for us
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

# python plugin: auto-activate .venv / venv on cd
PYTHON_VENV_NAME=".venv"
PYTHON_VENV_NAMES=($PYTHON_VENV_NAME venv)
PYTHON_AUTO_VRUN=true

zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' exact yes

plugins=(
    alias-finder
    fzf
    git
    macos
    python
)

# PATH is pinned BEFORE oh-my-zsh: its python plugin auto-activates a .venv at
# startup and saves PATH for deactivate. Saved before these pins, leaving the
# venv restores path_helper's order (Intel brew first) — seen 2026-09-24.
typeset -U path  # keep PATH deduped when this file is re-sourced

if [[ $OSTYPE == darwin* && -n $BREW_PREFIX ]]; then
    # This mac carries a second, Intel brew in /usr/local for universal builds.
    # path_helper lists /usr/local/bin FIRST, so without this the Intel brew
    # wins a bare `brew`. Pin the native one ahead of it.
    path=("$BREW_PREFIX/bin" "$BREW_PREFIX/sbin" $path)
    # keg-only llvm must beat Apple's clang; path_helper demoted it too
    [[ -d $BREW_PREFIX/opt/llvm/bin ]] && path=("$BREW_PREFIX/opt/llvm/bin" $path)
    # keg-only ruby must beat Apple's 2.6 in /usr/bin, which macOS owns and gem can't update
    [[ -d $BREW_PREFIX/opt/ruby/bin ]] && path=("$BREW_PREFIX/opt/ruby/bin" $path)

    # brew's repository dir is NOT its prefix on Intel, so ask brew itself
    cnf="$($BREW_PREFIX/bin/brew --repository)/Library/Homebrew/command-not-found/handler.sh"
    [[ -f $cnf ]] && source $cnf
    unset cnf

    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"   # common sets it once moved
    [[ -s $BREW_PREFIX/opt/nvm/nvm.sh ]] && source $BREW_PREFIX/opt/nvm/nvm.sh
    [[ -s $BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm ]] && source $BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm
fi

# macOS path_helper (/etc/zprofile) rebuilds PATH *after* .zshenv has run,
# demoting these behind brew's copies. Re-assert them here, where nothing else
# reorders. `typeset -U path` moves an existing entry rather than duplicating.
# Keep this list in sync with the prepend loop in ~/.config/shell/common.
# cargo's bin as well: a brew rust (a build dependency of many formulae) puts its own cargo in
# brew's bin, which path_helper lists first; rustup's must win for development
for d in "${CARGO_HOME:-$HOME/.cargo}/bin" "${JENV_ROOT:-$HOME/.jenv}/bin" "$PNPM_HOME" "${PNPM_HOME:+$PNPM_HOME/bin}" "$HOME/google-cloud-sdk/bin" "$HOME/.local/bin"; do
    [[ -d $d ]] && path=("$d" $path)
done

source $ZSH/oh-my-zsh.sh

source $ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh


# gcloud completion (PATH is handled portably in .shell_common)
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# `config` completes as git, but its work tree is all of $HOME. So for that repo:
#   - don't list untracked files (it walks ~1M files and hangs)
#   - list modified files by path, matched anywhere: `config add zshrc` -> zsh/.zshrc
# These replace two helpers in zsh's _git; other repos keep the originals' behaviour.
_in_dotfiles() { [[ $GIT_DIR == $HOME/dotfiles ]] }

__git_other_files() {
    _in_dotfiles && return 1
    __git_files --others untracked-files 'untracked file' "$@"
}

__git_modified_files() {
    if ! _in_dotfiles; then
        __git_files --modified modified-files 'modified file' "$@"
        return
    fi
    local -a changed expl
    changed=(${(f)"$(git ls-files --modified -- :/)"})
    _wanted modified-files expl 'modified file' compadd -M 'l:|=* r:|=*' -f -a changed
}

# zsh-syntax-highlighting must be sourced last
if [[ -n $TERMUX_VERSION ]]; then
    ZSH_PLUGIN_DIR="$ZSH/custom/plugins"
elif [[ $OSTYPE == darwin* ]]; then
    ZSH_PLUGIN_DIR="$BREW_PREFIX/share"
else
    ZSH_PLUGIN_DIR="/usr/share"
fi
for p in zsh-autosuggestions zsh-syntax-highlighting; do  # highlighting stays last
    [[ -r $ZSH_PLUGIN_DIR/$p/$p.zsh ]] && source $ZSH_PLUGIN_DIR/$p/$p.zsh
done
