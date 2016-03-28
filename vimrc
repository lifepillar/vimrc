" Modeline and Notes {{
" vim: set sw=2 ts=2 sts=0 et fmr={{,}} fdl=0 fdm=marker fdt=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" - To override the settings of a color scheme, create a file
"   after/colors/<theme name>.vim It will be automatically loaded after the
"   color scheme is activated.
"
" - To switch the color scheme when the background changes, define
"   a BackgroundToggle_<theme_name>() function that changes the color scheme.
"
" - For UTF-8 symbols to be displayed correctly (e.g., in the status line),
"   you may need to check "Set locale environment variables on startup" in OS
"   X Terminal.app's preferences, or "Set locale variables automatically" in
"   iTerm's Terminal settings. If UTF-8 symbols are not displayed in remote
"   sessions (that is, when you run Vim on a remote machine to which you are
"   connected via SSH), make sure that the following line is *not* commented
"   in the client's /etc/ssh_config:
"
"       SendEnv LANG LC_*
"
"   As a last resort, you may set LC_ALL and LANG manually on the server; e.g.,
"   put these in your remote machine's .bash_profile:
"
"       export LC_ALL=en_US.UTF-8
"       export LANG=en_US.UTF-8
" }}
" Environment {{
  set nocompatible " Must be first line
  " See http://stackoverflow.com/questions/18321538/vim-error-e474-invalid-argument-listchars-tab-trail
  if !&encoding ==# 'utf-8' | set encoding=utf-8 | endif
  scriptencoding utf-8
  set nobomb
  set fileformats=unix,mac,dos
  if exists('+langnoremap') | set langnoremap | endif
  set ttimeout
  set ttimeoutlen=0 " Faster feedback in status line when returning to normal mode
  set ttyfast
  set lazyredraw
  set mouse=a
  if !has('nvim')
    if has('mouse_sgr')
      set ttymouse=sgr " See :h sgr-mouse
    elseif $TERM =~# '^\%(screen\|tmux\)'
      set ttymouse=xterm2
    endif
  endif
  set updatetime=1000 " Trigger CursorHold event after one second
  syntax enable
  filetype on " Enable file type detection
  filetype plugin on " Enable loading the plugin files for specific file types
  filetype indent on " Load indent files for specific file types
  set sessionoptions-=options " See FAQ at https://github.com/tpope/vim-pathogen
  set autoread " Re-read file if it is changed by an external program
  set hidden " Allow buffer switching without saving
  set history=10000 " Keep a longer history (10000 is the maximum)
  " Consolidate temporary files in a central spot
  set backupdir=~/.vim/tmp/backup
  set directory=~/.vim/tmp/swap
  set viminfo^=!
  if !has('nvim')
    set viminfo+=n~/.vim/viminfo
  endif
  set undofile " Enable persistent undo
  set undodir=~/.vim/tmp/undo
  set undolevels=1000 " Maximum number of changes that can be undone
  set undoreload=10000 " Maximum number of lines to save for undo on a buffer reload
" }}
" Editing {{
  let g:default_scrolloff = 2
  let &scrolloff=g:default_scrolloff " Keep some context when scrolling
  set sidescrolloff=5 " Ditto, but for horizontal scrolling
  set autoindent " Use indentation of the first-line when reflowing a paragraph
  set backspace=indent,eol,start " Intuitive backspacing in insert mode
  set whichwrap+=<,>,[,],h,l " More intuitive arrow movements
  " Make Y behave like other capitals (use yy to yank the whole line)
  nnoremap Y y$
  " Smooth scrolling that works both in terminal and in GUI Vim
  nnoremap <silent> <c-u> :call <sid>smoothScroll(1)<cr>
  nnoremap <silent> <c-d> :call <sid>smoothScroll(0)<cr>
  " Scroll the viewport faster
  nnoremap <c-e> <c-e><c-e>
  nnoremap <c-y> <c-y><c-y>
  set nrformats=hex
  set showmatch " Show matching brackets/parenthesis
  set matchtime=2 " show matching bracket for 0.2 seconds
  set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
  set formatoptions+=1j " Do not wrap after a one-letter word and remove extra comment when joining lines
  if has('packages')
    packadd! matchit
  else
    runtime! macros/matchit.vim " Enable % to go to matching keyword/tag
  endif
  set smarttab
  set expandtab " Use soft tabs by default
  " Use two spaces for tab by default
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
" }}
" Find, replace, and completion {{
  set nohlsearch " Do not highlight search results
  set incsearch " Search as you type
  set ignorecase " Case-insensitive search by default
  set smartcase " Use case-sensitive search if there is a capital letter in the search expression
  set grepprg=ag\ --vimgrep grepformat^=%f:%l:%c:%m
  set keywordprg=:help " Get help for word under cursor by pressing K
  set complete-=i " Do not search included files
  set complete+=kspell " Use spell dictionary for completion, if available
  set completeopt+=menuone
  set tags=./tags;,tags " Search upwards for tags by default
  " Files and directories to ignore
  set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
  set wildmenu " Show possible matches when autocompleting
  set wildignorecase " Ignore case when completing file names and directories
" }}
" Appearance {{
  set display=lastline
  set notitle " Do not set the terminal title
  set number " Turn line numbering on
  set relativenumber " Display line numbers relative to the line with the cursor
  set nowrap " Don't wrap lines by default
  set linebreak " If wrapping is enabled, wrap at word boundaries
  set laststatus=2 " Always show status line
  set shortmess-=l " Don't use abbreviations for 'characters', 'lines'
  set shortmess-=r " Don't use abbreviations for 'readonly'
  set showcmd " Show (partial) command in the last line of the screen
  set diffopt+=vertical " Diff in vertical mode
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:• " Symbols to use for invisible characters
  let &showbreak='↪ '
  set tabpagemax=50
  " Printing
  if has('mac')
    set printexpr=system('open\ -a\ Preview\ '.v:fname_in)\ +\ v:shell_error
  endif
  set printoptions=syntax:n,number:y
  set printfont=Courier:h9 " Font is ignored; only the size is set

  " Resize windows when the terminal window size changes (from http://vimrcfu.com/snippet/186)
  autocmd VimResized * :wincmd =
  " Hook for overriding a theme's default
  autocmd ColorScheme * call <sid>customizeTheme()
" }}
" Status line {{
  " See :h mode() (some of these are never used in the status line; 't' is from NeoVim)
  let g:mode_map = {
        \ 'n':  ['NORMAL',  'NormalMode' ], 'no':     ['PENDING', 'NormalMode' ], 'v': ['VISUAL',  'VisualMode' ],
        \ 'V':  ['V-LINE',  'VisualMode' ], "\<c-v>": ['V-BLOCK', 'VisualMode' ], 's': ['SELECT',  'VisualMode' ],
        \ 'S':  ['S-LINE',  'VisualMode' ], "\<c-s>": ['S-BLOCK', 'VisualMode' ], 'i': ['INSERT',  'InsertMode' ],
        \ 'R':  ['REPLACE', 'ReplaceMode'], 'Rv':     ['REPLACE', 'ReplaceMode'], 'c': ['COMMAND', 'CommandMode'],
        \ 'cv': ['COMMAND', 'CommandMode'], 'ce':     ['COMMAND', 'CommandMode'], 'r': ['PROMPT',  'CommandMode'],
        \ 'rm': ['-MORE-',  'CommandMode'], 'r?':     ['CONFIRM', 'CommandMode'], '!': ['SHELL',   'CommandMode'],
        \ 't':  ['TERMINAL', 'CommandMode']}

  let g:ff_map = { "unix": "␊", "mac": "␍", "dos": "␍␊" }

  " newMode may be a value as returned by mode(1) or the name of a highlight group
  fun! s:updateStatusLineHighlight(newMode)
    execute 'hi! link CurrMode' get(g:mode_map, a:newMode, ["", a:newMode])[1]
    call s:setTransitionGroup("SepMode", "CurrMode", "StatusLine")
    return 1
  endf

  fun! SetupStl(nr)
    " Setting highlight groups while computing the status line may cause the
    " startup screen to disappear in MacVim. See:
    "
    "     https://github.com/powerline/powerline/issues/250
    "
    " I have experienced this issue under two circumstances:
    " 1) you open a window in MacVim (File > New Window), then you open a
    "    second window: the startup screen disappears in the first window.
    " 2) After installing YouCompleteMe, it happens every time.
    "
    " In a %{} context, winnr() always refers to the window to which the
    " status line being drawn belongs.
    return get(extend(w:, {
          \ "lf_active": winnr() != a:nr
            \ ? 0
            \ : (mode(1) ==# get(g:, "lf_cached_mode", "")
              \ ? 1
              \ : s:updateStatusLineHighlight(get(extend(g:, { "lf_cached_mode": mode(1) }), "lf_cached_mode"))
              \ ),
          \ "lf_winwd": winwidth(winnr())
          \ }), "", "")
  endf

  " Build the status line the way I want - no fat light plugins!
  fun! BuildStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"] ? "  " . get(g:mode_map, mode(1), [mode(1)])[0] . (&paste ? " PASTE " : " ") : ""}
          \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym : ""}%*
          \ %t
          \ %{&modified ? g:mod_sym : " "} %{&modifiable ? (&readonly ? g:ro_sym : " ") : g:ma_sym}
          \ %<%{w:["lf_winwd"] < 80 ? expand("%:p:h:t") : expand("%:p:h")}
          \ %=
          \ %{&ft} %{w:["lf_winwd"] < 80 ? "" : " " . (strlen(&fenc) ? &fenc : &enc) . (&bomb ? ",BOM " : " ")
          \ . get(g:ff_map, &ff, "?") . (&expandtab ? " ˽ " : " ⇥ ") . &tabstop}
          \ %#SepMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? g:right_sep_sym : ""}
          \%#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? ""
          \ : g:pad . printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))) : ""}
          \%#Warnings#%{w:["lf_active"] ? get(b:, "lf_stl_warnings", "") : ""}%*'
  endf
" }}
" Tabline {{
  " Define the highlight groups for the separator symbols in the tabline
  fun! s:setTabLineSepGroups()
    call s:setTransitionGroup("TabSepPreSel", "TabLine", "TabLineSel")
    call s:setTransitionGroup("TabSepSel", "TabLineSel", "TabLine")
    call s:setTransitionGroup("TabSepFill", "TabLine", "TabLineFill")
    call s:setTransitionGroup("TabSepSelFill", "TabLineSel", "TabLineFill")
    return s:getRealBackground("TabLine") == s:getRealBackground("TabLineFill")
  endf

  fun! s:tabLineSeparator(n)
    return (a:n + 1 == tabpagenr()
          \ ? "%#TabSepPreSel#" . g:left_sep_sym
          \ : (a:n == tabpagenr()
            \ ? (a:n == tabpagenr('$')
              \ ? "%#TabSepSelFill#" . g:left_sep_sym
              \ : "%#TabSepSel#" . g:left_sep_sym
              \ )
            \ : (a:n != tabpagenr('$') || s:two_color_tabline
              \ ? "%#TabSepSel#" . g:lalt_sep_sym
              \ : "%#TabSepFill#" . g:left_sep_sym
              \ )
            \ )
        \ )
  endf

  fun! BuildTabLabel(nr)
    return " " . a:nr
          \ . (empty(filter(tabpagebuflist(a:nr), 'getbufvar(v:val, "&modified")')) ? " " : " " . g:mod_sym . " ")
          \ . (get(extend(t:, {
          \ "tablabel": fnamemodify(bufname(tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1]), ":t")
          \ }), "tablabel") == "" ? "[No Name]" : get(t:, "tablabel")) . "  "
  endf

  fun! BuildTabLine()
    return join(map(
          \ range(1, tabpagenr('$')),
          \ '(v:val == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#") . "%".v:val."T %{BuildTabLabel(".v:val.")}" . s:tabLineSeparator(v:val)'
          \), '') . "%#TabLineFill#%T" . (tabpagenr('$') > 1 ? "%=%999X✕ " : "")
  endf

" }}
" GUI {{
  if has('gui_running')
    set guifont=Menlo:h11
    set guioptions-=aP " Do not use system clipboard by default
    set guioptions-=T  " No toolbar
    set guioptions-=lL " No left scrollbar
    set guioptions-=e  " Use Vim tabline
    set guicursor=n-v-c:ver20 " Use a thin vertical bar as the cursor
    set transparency=0
  endif
" }}
" Helper functions {{
  " See http://stackoverflow.com/questions/4064651/what-is-the-best-way-to-do-smooth-scrolling-in-vim
  fun! s:smoothScroll(up)
    execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
    redraw
    for l:count in range(3, &scroll, 2)
      sleep 10m
      execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
      redraw
    endfor
  endf

  " Return the real background color of the given highlight group
  fun! s:getRealBackground(hl)
    let l:col = synIDattr(synIDtrans(hlID(a:hl)), synIDattr(synIDtrans(hlID(a:hl)), "reverse") ? "fg" : "bg")
    if l:col == -1 || empty(l:col)  " First fallback
      let l:col = synIDattr(synIDtrans(hlID("Normal")), synIDattr(synIDtrans(hlID("Normal")), "reverse") ? "fg" : "bg")
      if l:col == -1 || empty(l:col) " Second fallback
        return (has("gui_running") || (has("termtruecolor") && &guicolors == 1)) ? "#FFFFFF" : "1"
      endif
    endif
    return l:col
  endf

  " Define or overwrite a highlight group hl using the following rule: the
  " foreground of hl is set equal to the background of fgHl; the background of
  " hl is set equal to the background of bgHl. Highlight groups defined in
  " this way are used as transition groups (separators) in the status line and
  " in the tab line.
  fun! s:setTransitionGroup(hl,fgHl, bgHl)
    execute 'hi! '. a:hl . (has('nvim') || has("gui_running") ?
          \ ' guifg='   . s:getRealBackground(a:fgHl) . ' guibg='   . s:getRealBackground(a:bgHl) :
          \ ' ctermfg=' . s:getRealBackground(a:fgHl) . ' ctermbg=' . s:getRealBackground(a:bgHl))
  endf

  fun! s:toggleBackgroundColor()
    if exists('g:colors_name')
      try
        call BackgroundToggle_{substitute(g:colors_name, '[-]', '_', 'g')}()
      catch /.*/
        let g:lf_cached_mode = ""  " Force updating status line highlight groups
        let &background = (&background == 'dark') ? 'light' : 'dark'
      endtry
    endif
  endf

  fun! s:customizeTheme()
    " Set the default values of our highlight groups for the status line
    hi! link NormalMode StatusLine
    hi! link InsertMode DiffText
    hi! link VisualMode Visual
    hi! link ReplaceMode DiffChange
    hi! link CommandMode PmenuSel
    hi! link Warnings ErrorMsg
    " Define our highlight groups for the tab line
    let s:two_color_tabline = s:setTabLineSepGroups()
    let g:lf_cached_mode = ""  " Force updating highlight groups
    " Set defaults for vertical separator and fold separator
    let &fillchars='vert: ,fold: '
    if strlen(get(g:, "colors_name", "")) " Inspired by AfterColors plugin
      execute "runtime after/themes/" . g:colors_name . ".vim"
    endif
  endf

  fun! s:enableStatusLine()
    augroup warnings
      autocmd!
      autocmd BufReadPost,BufWritePost * call <sid>updateWarnings()
    augroup END
    set noshowmode " Do not show the current mode because it is displayed in status line
    set noruler
    let g:default_stl = &statusline
    let g:default_tal = &tabline
    set statusline=%!BuildStatusLine(winnr()) " winnr() is always the number of the *active* window
    set tabline=%!BuildTabLine()
  endf

  fun! s:disableStatusLine()
    let &tabline = g:default_tal
    let &statusline = g:default_stl
    unlet g:default_tal
    unlet g:default_stl
    set ruler
    set showmode
    augroup warnings
      autocmd!
    augroup END
    augroup! warnings
  endf

  fun! s:enablePatchedFont()
    let g:left_sep_sym = "\ue0b0"
    let g:right_sep_sym = "\ue0b2"
    let g:lalt_sep_sym = "\ue0b1"
    let g:ralt_sep_sym = "\ue0b3"
    let g:ro_sym = "\ue0a2"
    let g:ma_sym = "✗"
    let g:mod_sym = "◇"
    let g:linecol_sym = "\ue0a1"
    let g:branch_sym = "\ue0a0"
    let g:pad = " "
  endf

  fun! s:disablePatchedFont()
    let g:left_sep_sym = ""
    let g:right_sep_sym = ""
    let g:lalt_sep_sym = ""
    let g:ralt_sep_sym = ""
    let g:ro_sym = "RO"
    let g:ma_sym = "✗"
    let g:mod_sym = "◇"
    let g:linecol_sym = ""
    let g:branch_sym = ""
    let g:pad = ""
  endf

  " Update trailing space and mixed indent warnings for the current buffer.
  " See http://got-ravings.blogspot.it/2008/10/vim-pr0n-statusline-whitespace-flags.html
  fun! s:updateWarnings()
    let l:sz = getfsize(bufname('%'))
    if l:sz >= g:LargeFile || l:sz == -2
      let b:lf_stl_warnings = '  Large file '
      return
    endif
    let l:winview = winsaveview() " Save window state
    call cursor(1,1) " Start search from the beginning of the file
    let l:trail = search('\s$', 'cnw')
    let l:spaces = search('\v^\s* ', 'cnw')
    let l:tabs = search('\v^\s*\t', 'cnw')
    if l:trail != 0
      let b:lf_stl_warnings = '  Trailing space ('.trail.') '
      if l:spaces != 0 && l:tabs != 0
        let b:lf_stl_warnings .= 'Mixed indent ('.spaces.'/'.l:tabs.') '
      endif
    elseif l:spaces != 0 && l:tabs != 0
      let b:lf_stl_warnings = '  Mixed indent ('.spaces.'/'.l:tabs.') '
    else
      unlet! b:lf_stl_warnings
    endif
    call winrestview(l:winview) " Restore window state
  endf

  " Delete trailing white space.
  fun! s:removeTrailingSpace()
    let l:winview = winsaveview() " Save window state
    %s/\s\+$//ge
    call winrestview(l:winview) " Restore window state
    call s:updateWarnings()
    redraw  " See :h :echo-redraw
    echomsg 'Trailing space removed!'
  endf

  " }}
" Commands (plugins excluded) {{
  " Grep search
  command! -nargs=* -complete=shellcmd Ag silent grep <args><bar>cwindow<bar>redraw!

  " Generate/update tags file (use :Ctags . to index the current directory)
  command! -nargs=* -complete=shellcmd Ctags execute 'cd ' fnameescape(expand('%:p:h')) <bar>
        \ !ctags -R --extra=+f --exclude=*.html <args> %:t:S

  " Fancy fonts
  command! -nargs=0 EnablePatchedFont call <sid>enablePatchedFont()
  command! -nargs=0 DisablePatchedFont call <sid>disablePatchedFont()

  " Custom status line
  command! -nargs=0 EnableStatusLine call <sid>enableStatusLine()
  command! -nargs=0 DisableStatusLine call <sid>disableStatusLine()

  " Find all in current buffer
  command! -nargs=1 FindAll call lf_find#buffer(<q-args>)

  " Find all in all open buffers
  command! -nargs=1 MultiFind call lf_find#all_buffers(<q-args>)

  " Execute an arbitrary (non-interactive) Git command and show the output in a new buffer.
  command! -complete=shellcmd -nargs=+ Git call lf_git#exec(<q-args>, "B")

  " Git diff
  command! -nargs=0 GitDiff call lf_git#diff()

  " Three-way diff.
  command! -nargs=0 Conflicts call lf_git#three_way_diff()

  if has('packages') " We may use :packadd, but YCM needs special treatment
    command! -nargs=0 LoadYCM call lf_loader#loadYCM()
  else
    " Load a blacklisted plugin
    command! -nargs=1 -complete=customlist,lf_loader#complete LoadPlugin call lf_loader#loadPlugin(<q-args>)
  endif

  " Execute an external command and show the output in a new buffer
  command! -complete=shellcmd -nargs=+ Shell      call lf_shell#run(<q-args>, "B")
  command! -complete=shellcmd -nargs=+ ShellBot   call lf_shell#run(<q-args>, "B")
  command! -complete=shellcmd -nargs=+ ShellRight call lf_shell#run(<q-args>, "R")
  command! -complete=shellcmd -nargs=+ ShellLeft  call lf_shell#run(<q-args>, "L")
  command! -complete=shellcmd -nargs=+ ShellTop   call lf_shell#run(<q-args>, "T")

  " Send text to a terminal
  command! BindTerminal call lf_terminal#open()
  command! REPLSendLine call lf_terminal#send([getline('.')])
  command! -range=% REPLSendSelection call lf_terminal#send(lf_text#selection(<line1>,<line2>))

  " Set the tab width for the current buffer
  command! -nargs=1 TabWidth call lf_text#set_tab_width(<q-args>)

  command! -nargs=0 ToggleBackgroundColor call <sid>toggleBackgroundColor()

  " Toggle soft wrap
  command! -nargs=0 ToggleWrap call lf_text#toggleWrap()

  " Save file with sudo
  command! -nargs=0  WW :w !sudo tee % >/dev/null
" }}
" Key mappings (plugins excluded) {{
  " Use space as alternative leader
  map <space> <leader>
  " A handy cheat sheet ;)
  nnoremap <silent> <leader>? :call lf_cheatsheet#open()<cr>
  " Enable outline mode for the current buffer
  nnoremap <silent> <leader>O :call lf_outliner#enable()<cr>
  " Change the contrast level for themes that support such feature (e.g.,
  " Solarized, Seoul256, Gruvbox). ReduceContrast and IncreaseContrast must be
  " defined in after/colors/<theme>.vim
  nmap <silent> <leader>- :ReduceContrast<cr>
  nmap <silent> <leader>+ :IncreaseContrast<cr>
  " Open file browser in the directory of the current buffer
  nnoremap <silent> <leader>e :Ex<cr>
  " Change to the directory of the current file
  nnoremap <silent> cd :cd %:h \| pwd<cr>
  nnoremap <silent> <leader>w :<c-u>update<cr>
  nnoremap <silent> [<space> :<c-u>put!=repeat(nr2char(10),v:count1)<cr>'[
  nnoremap <silent> ]<space> :<c-u>put=repeat(nr2char(10),v:count1)<cr>
  nnoremap <silent> ]a :<c-u>prev<cr>
  nnoremap <silent> [a :<c-u>next<cr>
  nnoremap <silent> ]b :<c-u>bn<cr>
  nnoremap <silent> [b :<c-u>bp<cr>
  nnoremap <silent> ]l :<c-u>lnext<cr>zz
  nnoremap <silent> [l :<c-u>lprevious<cr>zz
  nnoremap <silent> ]n :<c-u>/\v^[<\|=>]{7}<cr>
  nnoremap <silent> [n :<c-u>?\v^[<\|=>]{7}<cr>
  nnoremap <silent> ]q :<c-u>cnext<cr>zz
  nnoremap <silent> [q :<c-u>cprevious<cr>zz
  nnoremap <silent> ]t :<c-u>tn<cr>
  nnoremap <silent> [t :<c-u>tp<cr>
  nnoremap <silent> <leader>] :<c-u>call lf_text#set_tab_width(&tabstop + v:count1)<cr>
  nnoremap <silent> <leader>[ :<c-u>call lf_text#set_tab_width(&tabstop - v:count1)<cr>
  nnoremap <silent> cob :<c-u>ToggleBackgroundColor<cr>
  nnoremap <silent> coc :<c-u>setlocal cursorline!<cr>
  nnoremap          cod :<c-r>=&diff ? 'diffoff' : 'diffthis'<cr><cr>
  nnoremap <silent> coh :<c-u>set hlsearch! \| set hlsearch?<cr>
  nnoremap <silent> coi :<c-u>set ignorecase! \| set ignorecase?<cr>
  nnoremap <silent> cok :<c-u>let &l:scrolloff = (&l:scrolloff == 999) ? g:default_scrolloff : 999<cr>
  nnoremap <silent> col :<c-u>setlocal list!<cr>
  nnoremap <silent> con :<c-u>setlocal number!<cr>
  nnoremap <silent> cop :<c-u>setlocal paste!<cr>
  nnoremap <silent> cor :<c-u>setlocal relativenumber!<cr>
  nnoremap <silent> cos :<c-u>setlocal spell! \| set spell?<cr>
  nnoremap <silent> cot :<c-u>setlocal expandtab!<cr>
  nnoremap <silent> cow :<c-u>ToggleWrap<cr>
  " Remove trailing space globally
  nnoremap <silent> <leader>S :<c-u>call <sid>removeTrailingSpace()<cr>
  " Capitalize words in selected text (see h gU)
  vnoremap <silent> <leader>U :s/\%V\v<(.)(\w*)/\u\1\L\2/g<cr>
  " Go to tab 1/2/3 etc
  nnoremap <leader>1 1gt
  nnoremap <leader>2 2gt
  nnoremap <leader>3 3gt
  nnoremap <leader>4 4gt
  nnoremap <leader>5 5gt
  nnoremap <leader>6 6gt
  nnoremap <leader>7 7gt
  nnoremap <leader>8 8gt
  nnoremap <leader>9 9gt
  nnoremap <leader>0 10gt
  " Use bindings in command mode similar to those used by the shell (see also :h cmdline-editing)
  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-p> <up>
  cnoremap <c-n> <down>
  " Allow using alt-arrows to jump over words in OS X, as in Terminal.app
  cnoremap <esc>b <s-left>
  cnoremap <esc>f <s-right>
  " Move down in pop-up menu, or complete word (with omnifunc if available,
  " otherwise with ctrl-n), or just use tab. Define b:lf_tab_complete to
  " override the default mapping for completion.
  imap <expr><silent> <tab> pumvisible()
        \ ? "\<c-n>"
        \ : (col('.')>1 && (matchstr(getline('.'), '\%' . (col('.')-1) . 'c.') =~ '\S')
          \ ? (exists('b:lf_tab_complete')
            \ ? b:lf_tab_complete
            \ : (&omnifunc != '' ? "\<c-x>\<c-o>" : "\<c-n>")
            \ )
          \ : "\<tab>"
          \ )
  " Move up in pop-up menu or unindent in Insert mode
  inoremap <expr><silent> <s-tab> pumvisible() ? "\<c-p>" : "\<c-d>"
  " Make
  nnoremap <silent> <leader>m :<c-u>update<cr>:silent make<bar>redraw!<bar>cwindow<cr>
  " Terminal
  nnoremap <silent> <leader>x :<c-u>REPLSendLine<cr>
  vnoremap <silent> <leader>x :<c-u>REPLSendSelection<cr>
  " Git
  nnoremap <silent> <leader>gs :<c-u>call lf_git#status()<cr>
  nnoremap <silent> <leader>gc :<c-u>call lf_git#commit()<cr>
  nnoremap <silent> <leader>gb :<c-u>call lf_git#blame()<cr>
  nnoremap <silent> <leader>gd :<c-u>GitDiff<cr>
  nnoremap          <leader>gp :<c-u>Git push
  " Show the revision history for the current file (use :Git log for the full log)
  nnoremap <silent> <leader>gl :<c-u>Git log --oneline -- %<cr>
" }}
" Plugins {{
  " CtrlP {{
    " Open CtrlP in find buffer mode by default
    let g:ctrlp_cmd = 'CtrlPBuffer'
    " Get recently opened files with Ctrl-N
    nnoremap <silent> <c-n> :<c-u>CtrlPMRUFiles<cr>
    let g:ctrlp_switch_buffer = 0
    let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
    let g:ctrlp_status_func = {
          \ 'main': 'CtrlP_Main',
          \ 'prog': 'CtrlP_Progress',
          \ }
    let g:ctrlp_extensions = ['funky', 'tag']

    " Override some default names
    let s:ctrlp_section_map = {
          \ "mru files": "recent",
          \ "funky": "functions"
          \  }

    " See https://gist.github.com/kien/1610859
    " Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
    "            a:1    a:2      a:3       a:4  a:5   a:6  a:7
    fun! CtrlP_Main(...)
      let l:section = get(s:ctrlp_section_map, a:5, a:5)
      if a:1 ==# 'prt'
        call s:setTransitionGroup("CtrlPSepMode", "InsertMode", "StatusLine")
        return '%#InsertMode# ' . l:section . ' %#CtrlPSepMode#%{g:left_sep_sym}%* '
              \ . getcwd() . ' %= %#CtrlPSepMode#%{g:right_sep_sym}%#InsertMode#'
              \ . (a:3 ? ' regex ' : ' match ') . a:2 . ' %*'
      else
        call s:setTransitionGroup("CtrlPSepMode", "VisualMode", "StatusLine")
        return '%#VisualMode# ' . l:section . ' %#CtrlPSepMode#%{g:left_sep_sym}%* '
              \ . getcwd() . ' %= %#CtrlPSepMode#%{g:right_sep_sym}%#VisualMode# select %*'
      endif
    endf

    " Argument: len
    "           a:1
    fun! CtrlP_Progress(...)
      call s:setTransitionGroup("CtrlPSepMode", "Warnings", "StatusLine")
      return '%#Warnings# ' . a:1 . ' %#CtrlPSepMode#%{g:left_sep_sym}%* %= %#CtrlPSepMode#%{g:right_sep_sym}%<%#Warnings# ' . getcwd() . ' %*'
    endf
  " }}
  " Easy Align {{
    xmap <leader>a <plug>(EasyAlign)
    nmap <leader>a <plug>(EasyAlign)
  " }}
  " Goyo {{
    " Toggle distraction-free mode
    nnoremap <silent> <leader>f :Goyo<cr>
    fun! s:goyoEnter()
      if has('gui_running')
        "set fullscreen
        set linespace=5
        set guicursor=n-v-c:ver10
        set guioptions-=r " hide right scrollbar
      endif
      set scrolloff=999 " Keep the edited line vertically centered
      call lf_text#enableSoftWrap()
      set noshowcmd
      Limelight
    endf

    fun! s:goyoLeave()
      if has('gui_running')
        "set nofullscreen
        set linespace=0
        set guicursor=n-v-c:ver20
        set guioptions+=r
      endif
      set showcmd
      call lf_text#disableSoftWrap()
      let &scrolloff=g:default_scrolloff
      Limelight!
    endf

    autocmd! User GoyoEnter
    autocmd! User GoyoLeave
    autocmd! User GoyoEnter nested call <sid>goyoEnter()
    autocmd! User GoyoLeave nested call <sid>goyoLeave()
  " }}
  " Ledger {{
    let g:ledger_extra_options = '--check-payees --explicit --pedantic --wide'
    let g:ledger_maxwidth = 63
    let g:ledger_fillstring = ''
    let g:ledger_fold_blanks = 1
    let g:ledger_decimal_sep = ','
    let g:ledger_align_at = 60
    let g:ledger_default_commodity = 'EUR'
    let g:ledger_commodity_before = 0
    let g:ledger_commodity_sep = ' '
  " }}
  " Markdown (Vim) {{
    let g:markdown_fenced_languages = ['pgsql', 'sql']
  " }}
  " Netrw (Vim) {{
    let g:netrw_dirhistmax=0
    let g:netrw_banner=0
    let g:netrw_bufsettings='noma nomod nu rnu nowrap ro nobl'
    let g:netrw_list_hide=',\.DS_Store,Icon\?,\.dmg$,^\.git/,\.pyc$,\.o$,\.obj$,\.so$,\.swp$,\.zip$'
    let g:netrw_sort_options='i'
  " }}
  " Show Marks {{
    fun! s:toggleShowMarks()
      if exists('b:showmarks')
        NoShowMarks
      else
        DoShowMarks
      endif
    endf

  " Toggle marks
    nnoremap <silent> <leader>M :call <sid>toggleShowMarks()<cr>
    nnoremap ` :ShowMarksOnce<cr>`
  " }}
  " Sneak {{
    let g:sneak#streak = 1
    let g:sneak#use_ic_scs = 1 " Match according to ignorecase and smartcase
    hi link SneakStreakStatusLine StatusLine
  " }}
  " SQL (Vim) {{
    let g:sql_type_default = 'pgsql'
  " }}
  " Syntastic {{
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_cursor_columns = 0
    let g:syntastic_error_symbol = '⦿'
    let g:syntastic_warning_symbol = '●'
    let g:syntastic_style_error_symbol = '»'
    let g:syntastic_style_warning_symbol = '»'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_loc_list_height = 5
    let g:syntastic_aggregate_errors = 1
  " }}
  " Tagbar {{
    fun! TagbarStatusLine(current, sort, fname, flags, ...) abort
      return a:current
            \ ? '%#NormalMode# Tagbar %#SepMode#%{g:left_sep_sym}%* ' . a:fname
            \ : '%#StatusLineNC# Tagbar ' . a:fname
    endf

    " Toggle tag bar
    nnoremap <silent> <leader>t :TagbarToggle<cr>
    let g:tagbar_autofocus = 1
    let g:tagbar_iconchars = ['▸', '▾']
    let g:tagbar_status_func = 'TagbarStatusLine'

    let g:tagbar_type_pgsql = {
          \ 'ctagstype': 'sql',
          \ 'kinds': [
          \ 't:tables',
          \ 'V:views',
          \ 'i:indexes',
          \ 'f:functions',
          \ 'T:triggers',
          \ 'D:types',
          \ 'q:sequences',
          \ 'o:other'
          \ ],
          \ 'sort': 1
          \ }
    let g:tagbar_type_markdown = {
          \ 'ctagstype': 'markdown',
          \ 'kinds': [
          \ 's:sections',
          \ 'l:links',
          \ 'i:images'
          \ ],
          \ 'sort': 0
          \ }
    let g:tagbar_type_tex = {
          \ 'ctagstype': 'latex',
          \ 'kinds': [
          \ 's:sections',
          \ 'g:graphics:0:0',
          \ 'l:labels',
          \ 'r:refs:1:0',
          \ 'p:pagerefs:1:0'
          \ ],
          \ 'sort': 0
          \ }
  " }}
  " UltiSnips {{
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsEditSplit = "vertical" " Edit snippets in a vertical split
  " }}
  " Undotree {{
    let g:undotree_WindowLayout = 2
    let g:undotree_SplitWidth = 40
    let g:undotree_SetFocusWhenToggle = 1
    let g:undotree_TreeNodeShape = '◦'
    " Toggle undo tree
    nnoremap <silent> <leader>u :UndotreeToggle<cr>
  " }}
  " YouCompleteMe {{
    let g:ycm_autoclose_preview_window_after_completion = 1
  " }}
  " 2HTML (Vim) {{
    let g:html_pre_wrap=1
    let g:html_use_encoding="UTF-8"
    let g:html_font=["Consolas", "Menlo"]
  " }}
" }}
" Themes {{
  " Gruvbox {{
    let g:gruvbox_bold = 0
  " }}
  " Seoul256 {{
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255
  " }}
  " Solarized {{
    let g:solarized_bold = 1
    let g:solarized_underline = 0
  " }}
" }}
" NeoVim {{
  if has('nvim')
    let g:terminal_scrollback_buffer_size = 10000
    if $TERM_PROGRAM ==# 'iTerm.app' && !exists('$TMUX')
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
  endif
" }}
" Init {{
  let g:LargeFile = 20*1024*1024

  DisablePatchedFont
  EnableStatusLine

  if !has('packages') " Use Pathogen as a fallback
    runtime pack/bundle/opt/pathogen/autoload/pathogen.vim " Load Pathogen
    let g:pathogen_blacklist = ['csapprox', 'syntastic', 'tagbar', 'undotree', 'youcompleteme']
    execute pathogen#infect('pack/bundle/start/{}', 'pack/bundle/opt/{}', 'pack/themes/opt/{}')
  endif

  " Local settings
  " If this file exists, it should at least define the color scheme
  if filereadable($HOME . '/.vim/vimrc_local.vim')
    execute 'source' $HOME . '/.vim/vimrc_local.vim'
  else
    colorscheme solarized
  endif
" }}

