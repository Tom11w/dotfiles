## How I set up this repo
```
git init --bare $HOME/dotfiles
    alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
    config config status.showUntrackedFiles no
```

```
git clone --separate-git-dir=$HOME/dotfiles/path/to/repo $HOME/myconf-tmp
    cp ~/myconf-tmp/.gitmodules ~  # If you use Git submodules
    rm -r ~/myconf-tmp/
    alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
```

https://news.ycombinator.com/item?id=11071754

## Moving an existing machine onto the `.config` layout

Found doing this on the 2019 mac, 2026-09-08. Three things bite, in this order.

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
