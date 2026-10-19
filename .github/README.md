## Install command.
```
curl -fsSL https://raw.githubusercontent.com/Tom11w/dotfiles/master/.github/setup.sh | sh
```

## How to create a repo like this
```
git init --bare $HOME/dotfiles
    alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
    config config status.showUntrackedFiles no
```


## How to then clone it.
```
git clone --separate-git-dir=$HOME/dotfiles/path/to/repo $HOME/myconf-tmp
    cp ~/myconf-tmp/.gitmodules ~  # If you use Git submodules
    rm -r ~/myconf-tmp/
    alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
```

https://news.ycombinator.com/item?id=11071754

## Moving an existing machine onto the `.config` layout

Found doing this on the 2019 mac, 2026-09-08 (sections 1–3), then the move of tools' own
folders out of `$HOME`, 2026-10-17 (section 4). Do them in this order.

### 1. A few untracked files block the pull — and one of them is your SSH agent

Files the incoming commits *add* that already exist locally and untracked will stop a
fast-forward. On that machine they were `.profile`, `.zshenv` and
`.config/git/allowed_signers`. Re-derive the list rather than trusting this one:

```sh
config fetch origin
config diff --name-status --diff-filter=AM master..origin/master
# for each result: does it exist in $HOME, and is it untracked?
```

**Export the agent socket before deleting anything.** `.zshenv` is what sets
`SSH_AUTH_SOCK`; delete it and you lose the credential the pull itself needs, leaving the
old files gone and the new ones unreachable. The replacement only arrives *with* the pull.

```sh
export SSH_AUTH_SOCK=/var/run/allthenticate-ssh.sock   # whatever the agent uses here
mkdir -p ~/dotfiles-preflight-backup && cp -a ~/.profile ~/.zshenv ~/dotfiles-preflight-backup/
rm -f ~/.profile ~/.zshenv ~/.config/git/allowed_signers
config pull --ff-only origin master
```

Check `ssh-add -L` lists a key first — an agent with no identities fails the same way and
looks like a permissions problem.

### 2. tmux: the plugins do not move with the config

`tmux.conf` runs `~/.config/tmux/plugins/tpm/tpm` and catppuccin from that same tree. An
older machine has them under `~/.tmux/plugins/`, so both `run` lines **silently do
nothing** — stock green status bar, and no tpm, which means no resurrect/continuum and no
session restore. One cause, both symptoms.

```sh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins
```

Resurrect saves live in `~/.local/share/tmux/resurrect/`, and `last` is a symlink naming
the one that prefix+Ctrl-r restores — not necessarily the newest or the fullest. **Back
that directory up before starting tmux**: continuum saves every minute and will roll over
it.

### 3. nvim: `telescope-fzf-native` must be compiled on each machine

After the lazy → vim.pack move the plugin lives under
`~/.local/share/nvim/site/pack/core/opt/`, and startup fails with
`dlopen(… build/libfzf.so): no such file`. The `PackChanged` hook in `telescope.lua`
builds it when the plugin *updates*, not on a machine where it was merely downloaded.

```sh
make -C ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim
file ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim/build/libfzf.so
```

Check the architecture — a copy built on another machine is the wrong one and fails just
as opaquely. An old `~/.local/share/nvim/lazy/` tree may still hold a stale `libfzf.so`;
that is dead weight, not the file nvim loads.

### 4. Tools' own folders: move them, then the config follows

`shell/common` sets the XDG base directories (`~/.config`, `~/.local/share`,
`~/.local/state`, `~/.cache`) and points each tool at its XDG folder **only once that folder
exists**. Pulling the config therefore changes nothing on its own: a tool switches when its
folder is moved. Move them with the tools closed, then open new shells (running shells keep
the old paths; oh-my-zsh loads its functions lazily from its folder):

```sh
sh ~/.github/xdg-move.sh
```

It prints each folder it moves and skips anything already moved or not installed, so it is
safe to re-run. What moves where:

| From `$HOME` | To | Read through |
|---|---|---|
| `.cargo`, `.rustup` | `~/.local/share/cargo`, `…/rustup` | `CARGO_HOME`, `RUSTUP_HOME` (cargo's `bin` goes on PATH directly; the old `~/.cargo/env` names the old path) |
| `.nvm` | `~/.local/share/nvm` | `NVM_DIR` |
| `.oh-my-zsh` | `~/.local/share/oh-my-zsh` | `ZSH` |
| `.jenv` | `~/.local/share/jenv` | `JENV_ROOT` |
| `.gradle` | `~/.local/share/gradle` | `GRADLE_USER_HOME` in a shell; Android Studio does not read it, so also set Settings › Build, Execution, Deployment › Build Tools › Gradle › *Gradle user home* to the same folder |
| `.npm` (cache) | `~/.cache/npm` | `NPM_CONFIG_CACHE` |
| `.gem` | `~/.local/share/gem`, `~/.cache/gem` | RubyGems' own default once `~/.gem` is gone |
| `.dotnet`, `.templateengine` | `~/.local/share/dotnet/` | `DOTNET_CLI_HOME` (dotnet keeps both inside it) |
| `.nuget/packages` | `~/.cache/NuGetPackages` | `NUGET_PACKAGES` |
| `.ansible` | `~/.local/share/ansible` | `ANSIBLE_HOME` |
| `.boto` | `~/.config/gcloud/boto` | `BOTO_CONFIG` |
| `.ipython`, `.jupyter`, `.matplotlib` | `~/.config/…` | `IPYTHONDIR`, `JUPYTER_CONFIG_DIR`, `MPLCONFIGDIR` |
| `.terminfo` | `~/.local/share/terminfo` | `TERMINFO_DIRS` (keeps a terminal's own `TERMINFO`) |
| `.wget-hsts` | `~/.local/share/wget-hsts` | `~/.config/wget/wgetrc`, via `WGETRC` |
| `.bash_history` | `~/.local/state/bash/history` | `HISTFILE` (zsh's is set in `zsh/.zshrc`) |
| `.python_history` | `~/.local/state/python/history` | `PYTHON_HISTORY` (Python 3.13+) |
| `.node_repl_history` | `~/.local/state/node/repl_history` | `NODE_REPL_HISTORY` |
| `.lesshst` | `~/.local/state/less/history` | `LESSHISTFILE` |
| `.homebrew/trust.json` | `~/.config/homebrew/trust.json` | brew's own default once `XDG_CONFIG_HOME` is set; if brew made a new one first, the script skips it: re-add the old entries with `brew trust --formula …` / `--cask …` / `--tap …` |

Then check in a new shell: `cargo --version`, `rustup show home`, `omz version`,
`jenv version`, `gem env user_gemhome`, `npm config get cache`.

If oh-my-zsh's folder was missing its theme (`no such file or directory:
…/custom/themes/powerlevel10k/powerlevel10k.zsh-theme`), clone it into the moved folder:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH/custom/themes/powerlevel10k"
```
