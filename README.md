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
