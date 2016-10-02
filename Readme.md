## My Vim setup

![WWDC16](https://raw.github.com/lifepillar/Resources/master/vimrc/screenshot.png)

My own Vim configuration. Some features:

- Foldable and thoroughly commented `vimrc`.
- Put your customizations into `.vimrc_local`.
- 40-column **cheat sheet** always two keys away (courtesy of
  [Cheat40](https://github.com/lifepillar/vim-cheat40)).
- Handcrafted, collapsible, fully customizable, **"plugin-free" status line**
  (let Vim spend a few tens of microseconds on updating the status line rather
  than the several milliseconds that plugins “as light as air” need). It used to
  support Powerline fonts up to commit
  [ca915737](https://github.com/lifepillar/vimrc/commit/ca9157376be876b030e5306adf38efd7093b870a),
  when I decided that simple is better (and Powerline fonts are an ugly hack
  anyway).
- **Distraction-free mode** (courtesy of
  [Goyo](https://github.com/junegunn/goyo.vim) and
  [Limelight](https://github.com/junegunn/limelight.vim)).
- Etc... (read the cheat sheet and the source!)


### Requirements

- A fairly recent Vim (7.4 or later) (`brew install vim` recommended on OS X).

Recommended:

- Vim 8.
- [The Silver Searcher, aka Ag](https://github.com/ggreer/the_silver_searcher);
- [Exuberant ctags](http://ctags.sourceforge.net);
- [fzf](https://github.com/junegunn/fzf).


### Installation

```sh
    cd ~
    git clone --depth 1 https://github.com/lifepillar/vimrc.git .vim
    cd .vim
    git checkout -b local
    # We use shallow submodules; --remote makes sure we are able to check them out:
    git submodule update --init --remote
    # Commit changes (needed only if there are changes):
    git commit -a -m "Git submodule update --remote."
```


### Update

```sh
    cd ~/.vim
    git checkout master
    git pull origin master
    git submodule sync
    git submodule update --init --recursive
    git checkout local
    git rebase master
```

…and fix conflicts.


### Update plugins and colorschemes

Make sure the repo is in a clean state.

```sh
    git submodule update --remote --depth 1
    git commit -a
    git submodule update --recursive # Optional, only if there are plugins with submodules
```


### How to add a new plugin or colorscheme

To add a plugin `Foo` from `https://repo/foo.git`:

```sh
    git submodule add --name foo --depth 1 https://repo/foo.git pack/bundle/start/foo
    git config -f .gitmodules submodule.foo.shallow true
    git add .gitmodules
    git commit
```

To add `Foo` as an optional plugin, change `start` with `opt` (it works if Vim
has packages, otherwise you also have to add the plugin to
`g:pathogen_blacklist`).

To add a colorscheme, change `bundle/start` with `themes/opt`.


### Useful resources

- [usevim](http://usevim.com/)
- [VimGolf](http://vimgolf.com)
- [VimAwesome](http://vimawesome.com)
- [vimrcfu](http://vimrcfu.com)
- [vim-galore](https://github.com/mhinz/vim-galore)
- [vimcolors](http://vimcolors.com)

