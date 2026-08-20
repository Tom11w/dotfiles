# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

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

source $ZSH/oh-my-zsh.sh

source $ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh

typeset -U path  # keep PATH deduped when this file is re-sourced

if [[ $OSTYPE == darwin* && -n $BREW_PREFIX ]]; then
    # This mac carries a second, Intel brew in /usr/local for universal builds.
    # path_helper lists /usr/local/bin FIRST, so without this the Intel brew
    # wins a bare `brew`. Pin the native one ahead of it.
    path=("$BREW_PREFIX/bin" "$BREW_PREFIX/sbin" $path)

    # brew's repository dir is NOT its prefix on Intel, so ask brew itself
    cnf="$($BREW_PREFIX/bin/brew --repository)/Library/Homebrew/command-not-found/handler.sh"
    [[ -f $cnf ]] && source $cnf
    unset cnf

    export NVM_DIR="$HOME/.nvm"
    [[ -s $BREW_PREFIX/opt/nvm/nvm.sh ]] && source $BREW_PREFIX/opt/nvm/nvm.sh
    [[ -s $BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm ]] && source $BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm
fi

# gcloud completion (PATH is handled portably in .shell_common)
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# the `config` alias is git, so complete it like git (needs compinit, hence here)
compdef config=git

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
