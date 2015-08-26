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
The following themes are supported:

- [Solarized](https://github.com/altercation/vim-colors-solarized) (light/dark)
- [Jellybeans](https://github.com/nanotech/jellybeans.vim) (dark)
- [PaperColor](https://github.com/NLKNguyen/papercolor-theme) (light/dark)
- [Pencil](https://github.com/reedes/vim-colors-pencil) (light/dark)
- [Seoul256](https://github.com/junegunn/seoul256.vim) (light/dark)
- [Tomorrow](https://github.com/chriskempson/vim-tomorrow-theme) (light/dark)

The following themes look fine in MacVim, but may be suboptimal choices in
Terminal.app:

- [Gruvbox](https://github.com/morhetz/gruvbox) (light/dark): this looks fine in
  iTerm, however, provided that you run
  `.vim/bundle/gruvbox/gruvbox_256palette_osx.sh`.
- [Pencil](https://github.com/reedes/vim-colors-pencil) (light/dark)

Solarized is the default theme. To use a different theme, put a file called
`vimrc_extra.vim` inside `.vim` and load your color scheme there.

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

- A fairly recent Vim (7.4 or later) (`brew install vim` recommended on OS X).
- [The Silver Searcher, aka Ag](https://github.com/ggreer/the_silver_searcher).
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
    git submodule sync
    git submodule update --recursive
    git checkout local
    git rebase master

…and fix conflicts.

### Update plugins

    git submodule update --remote --recursive

###  Some features

- A **cheat sheet** always at hand with `\?`.
- Foldable and thoroughly commented `vimrc`.
- **Distraction-free mode** (courtesy of
    [Goyo](https://github.com/junegunn/goyo.vim) and
    [Limelight](https://github.com/junegunn/limelight.vim)).
- Keeps the edited line vertically centered.
- Handcrafted, collapsible, fully customizable, **"plugin-free" status line**
  (let Vim spend a few tens of microseconds on updating the status line, rather
  than the several milliseconds that plugins “as light as air” need). And yes,
  it supports Powerline fonts!
- Key bindings in command mode similar to those used by the shell.
- Etc... (read the cheat sheet and the source!)


### Using patched fonts

You may enable or disable the use of fancy symbols at any time with
`:EnablePatchedFont` and `:DisablePatchedFont`, respectively. To make the
change permanent, put the following line in `~/.vim/vimrc_extra.vim`:

    EnablePatchedFont

To create a patched version of any of your fonts, you may use this [font
patcher](https://github.com/powerline/fontpatcher). Just make a backup copy of
the font, and then:

    fontforge -script ./scripts/powerline-fontpatcher MyFont.ttf

Note that in some cases you may need to adjust the line spacing to have the
symbols (especially the arrows) properly aligned. If you use OS X Terminal,
this can be done in Preferences > Text > Change…

**Important:** not all patched fonts are born equal! Some define the special
glyphs only in the range `U+2B60`–`U+2BFF`: *these will not work*. The special
glyphs must be stored in `U+E0B0`–`U+E0BF` (this is also the range that [Vim
Airline](https://github.com/bling/vim-airline) uses). To test whether your
patched font is compatible, you may type some of those Unicode codes in Vim:
for example, type `i«C-v»ue0b0` (`«C-v»` is Control-V, the
rest is typed literally). If you see a triangle, you're good to go!


### Useful resources

Apart from the obvious ones (e.g., [vim.wikia.com](http://vim.wikia.com)), I
have found the following interesting:

- [usevim](http://usevim.com/)
- [VimGolf](http://vimgolf.com)
- [VimAwesome](http://vimawesome.com)
- [vimrcfu](http://vimrcfu.com)

