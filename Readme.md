## My Vim setup

This repository contains my own Vim configuration, including a few plugins
(as submodules). I use this on OS X: some things might be changed for other systems.

### Requirements

- A fairly recent Vim (7.3 or later) (`brew install vim` recommended on OS X).
- [Exuberant ctags](http://ctags.sourceforge.net) to use Tagbar (`brew install ctags` on OS X).

### Installation

    git clone https://github.com/lifepillar/lifepillar-vim-config.git ~/.vim
    cd ~/.vim
    git submodule init
    git submodule update
    mkdir tmp
    git checkout -b local

Tweak to your taste!

### Update

    git checkout master
    git pull origin master
    git checkout local
    git rebase master

Fix conflicts.

### Features

TODO

### How it looks like

TODO
