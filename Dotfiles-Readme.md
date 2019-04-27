# Config gnpar

Based on [this guy's setup](https://news.ycombinator.com/item?id=11071754).

# Setup on a new system

Add alias:

    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

Clone bare repo:

    git clone --bare git@github.com:gnpar/dotfiles.git $HOME/.dotfiles

Checkout the files:

    config checkout

And don't show untracked files:

    config config --local status.showUntrackedFiles no

# Working with repo

The same as using git, but use config instead. So `config status/add/commit/push` as necessary.

To see what files are in repo: `config ls-files`

# Pick and choose

There's two ways to get a single config file:

1. Clone the bare repo and setup the alias as detailed above, then do:

      config checkout -- <file>

2. Find the URL to the raw file on github and download it with wget or curl:

      wget https://raw.githubusercontent.com/gnpar/dotfiles/master/.vimrc
