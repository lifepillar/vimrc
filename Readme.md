## My Vim setup

This repository contains my own Vim setup, which includes a `vimrc` file and a
few plugins (as Git submodules). This configuration is mostly built from other
people's code and ideas, but I haven't kept track of my many sources of
inspiration. If you feel that I should cite the source of some snippet, please
let me know! Note that I use this on OS X: minor modifications might be
necessary for other systems.

### Supported themes

I like to use both dark and light themes, even in the terminal, and I like to
switch between them depending on light conditions, my mood, or file content.
The following themes are supported both in the terminal and in MacVim:

- [Solarized](https://github.com/altercation/vim-colors-solarized) (light/dark)
- [PaperColor](https://github.com/NLKNguyen/papercolor-theme) (light)
- [Seoul256](https://github.com/junegunn/seoul256.vim) (light/dark)

Solarized is the default theme. To use a different theme, put a file called
`default-theme.vim` inside `.vim` and load your color scheme there.

The 16 color version of Solarized is used, so your terminal **must** be
configured to use Solarized, too! The other themes are 256 color themes, which
should display just fine in MacVim, and use very similar, if not identical,
colors in the terminal, no matter what colors the terminal is using.

Use `cob` (for “change option: background”) to switch between light and dark
background for themes that support both.

### How it looks like

![Solarized Dark](screenshots/solarized_dark.png)

![Solarized Light](screenshots/solarized_light.png)

### Requirements

- A fairly recent Vim (7.3 or later) (`brew install vim` recommended on OS X).
- [Exuberant ctags](http://ctags.sourceforge.net) to use Tagbar (`brew install ctags` on OS X).

### Installation

    cd
    git clone --recursive https://github.com/lifepillar/lifepillar-vim-config.git .vim
    cd .vim
    mkdir tmp
    git checkout -b local

…and tweak to your taste!

### Update

    cd ~/.vim
    git checkout master
    git pull origin master
    git checkout local
    git rebase master

…and fix conflicts.

### Update plugins

    git submodule update --remote

###  Some features

- A **cheat sheet** always at hand with `\?`.
- Foldable and thoroughly commented `vimrc`.
- **Distraction-free mode** (toggle with `<F7>`).
- Keeps the edited line vertically centered.
- Handcrafted, collapsible, **"plugin-free" status line**.
- Key bindings in command mode similar to those used by the shell.
- Etc... (read the cheat sheet and the source!)

