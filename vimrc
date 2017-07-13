" Modeline and Notes {{
" vim: set sw=2 ts=2 sts=0 et fmr={{,}} fcs=vert\:| fdm=marker fdt=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" - To override the settings of a color scheme, create a file
"   after/colors/<theme name>.vim It will be automatically loaded after the
"   color scheme is activated.
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
  set encoding=utf-8
  scriptencoding utf-8
  set nobomb
  set fileformats=unix,mac,dos
  if has('langmap') && exists('+langremap') | set nolangremap | endif
  set ttimeout
  set ttimeoutlen=50  " This must be a low value for <esc>-key not to be confused with an <a-…> mapping
  set ttyfast
  set mouse=a
  if !has('nvim')
      " Allow using alt-arrows to jump over words in macOS without slowing down <esc>. See :help :set-termcap
      set <s-left>=b
      set <s-right>=f
      cmap b <s-left>
      cmap f <s-right>
      " Prepare for using alt-hjkl to move between windows
      set <a-h>=h
      set <a-j>=j
      set <a-k>=k
      set <a-l>=l
      imap h <a-h>
      imap j <a-j>
      imap k <a-k>
      imap l <a-l>
    if &term =~# '^\%(tmux\|screen\)'
      set ttymouse=xterm2
      " Make bracketed paste mode work inside tmux:
      let &t_BE = "\033[?2004h"
      let &t_BD = "\033[?2004l"
      let &t_PS = "\033[200~"
      let &t_PE = "\033[201~"
    endif
    if has('mouse_sgr')
      set ttymouse=sgr " See :h sgr-mouse
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
  set viminfo=!,'1000,<10000,s10,h,n~/.vim/viminfo
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
  set shiftround " Round indent to multiple of shiftwidth (applies to < and >)
  set backspace=indent,eol,start " Intuitive backspacing in insert mode
  set whichwrap+=<,>,[,],h,l " More intuitive arrow movements
  " Smooth scrolling that works both in terminal and in GUI Vim
  nnoremap <silent> <c-u> :call <sid>smoothScroll(1)<cr>
  nnoremap <silent> <c-d> :call <sid>smoothScroll(0)<cr>
  " Scroll the viewport faster
  nnoremap <c-e> <c-e><c-e>
  nnoremap <c-y> <c-y><c-y>
  set nrformats=hex
  set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
  set splitright " When splitting vertically, focus goes to the right window
  set splitbelow " When splitting horizontally, focus goes to the bottom window
  set formatoptions+=1j " Do not wrap after a one-letter word and remove extra comment when joining lines
  if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
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
  set infercase " Smart case when doing keyword completion
  set smartcase " Use case-sensitive search if there is a capital letter in the search expression
  if executable('rg')
    set grepprg=rg\ -i\ --vimgrep
  endif
  set grepformat^=%f:%l:%c:%m
  set keywordprg=:help " Get help for word under cursor by pressing K
  set complete+=i      " Use included files for completion
  set complete+=kspell " Use spell dictionary for completion, if available
  set completeopt+=menuone,noselect
  set completeopt-=preview
  set tags=./tags;,tags " Search upwards for tags by default
  " Files and directories to ignore
  set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
  set wildmenu " Show possible matches when autocompleting
  set wildignorecase " Ignore case when completing file names and directories
  " Cscope
  set cscoperelative
  set cscopequickfix=s-,c-,d-,i-,t-,e-
  if has('patch-7.4.2033') | set cscopequickfix+=a- | endif
" }}
" Appearance {{
  if has('termguicolors') && $TERM_PROGRAM ==# 'iTerm.app'
    let &t_8f = "\<esc>[38;2;%lu;%lu;%lum" " Needed in tmux
    let &t_8b = "\<esc>[48;2;%lu;%lu;%lum" " Ditto
    set termguicolors
  endif
  set display=lastline
  set showtabline=2 " Always show the tab bar
  " Show block cursor in Normal mode and line cursor in Insert mode:
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
  set notitle " Do not set the terminal title
  set number " Turn line numbering on
  set relativenumber " Display line numbers relative to the line with the cursor
  set report=0 " Always show # number yanked/deleted lines
  set nowrap " Don't wrap lines by default
  set linebreak " If wrapping is enabled, wrap at word boundaries
  set laststatus=2 " Always show status line
  set shortmess-=lr " Don't use abbreviations for 'characters', 'lines', 'readonly'
  set shortmess+=cI " No intro and suppress ins-completion messages
  set showcmd " Show (partial) command in the last line of the screen
  set diffopt+=vertical " Diff in vertical mode
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:•,precedes:←,extends:→  " Symbols to use for invisible characters
  let &showbreak='↪ '
  set tabpagemax=50
  " Printing
  if has('mac')
    fun! LFPrintFile(fname)
      call system('pstopdf ' . a:fname)
      call system('open -a Preview ' . a:fname . '.pdf')
      call delete(a:fname)
      call delete(a:fname.'.pdf')
      return v:shell_error
    endf
    set printexpr=LFPrintFile(v:fname_in)
  endif
  set printoptions=syntax:n,number:y
  set printfont=:h9

  augroup lf_appearance
    autocmd!
    " Resize windows when the terminal window size changes (from http://vimrcfu.com/snippet/186)
    autocmd VimResized * wincmd =
    " Hook for overriding a theme's default
    autocmd ColorScheme * call <sid>customizeTheme()
    " On opening a file, jump to the last known cursor position (see :h line())
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !=# 'commit' |
      \   exe "normal! g`\"" |
      \ endif
  augroup END
" }}
" Status line {{
  " See :h mode() (some of these are never used in the status line; 't' is from NeoVim)
  let g:mode_map = {
        \  'n': ['NORMAL',  'NormalMode' ],     'no': ['PENDING', 'NormalMode'  ],  'v': ['VISUAL',  'VisualMode' ],
        \  'V': ['V-LINE',  'VisualMode' ], "\<c-v>": ['V-BLOCK', 'VisualMode'  ],  's': ['SELECT',  'VisualMode' ],
        \  'S': ['S-LINE',  'VisualMode' ], "\<c-s>": ['S-BLOCK', 'VisualMode'  ],  'i': ['INSERT',  'InsertMode' ],
        \ 'ic': ['COMPLETE','InsertMode' ],     'ix': ['CTRL-X',  'InsertMode'  ],  'R': ['REPLACE', 'ReplaceMode'],
        \ 'Rc': ['COMPLETE','ReplaceMode'],     'Rv': ['REPLACE', 'ReplaceMode' ], 'Rx': ['CTRL-X',  'ReplaceMode'],
        \  'c': ['COMMAND', 'CommandMode'],     'cv': ['COMMAND', 'CommandMode' ], 'ce': ['COMMAND', 'CommandMode'],
        \  'r': ['PROMPT',  'CommandMode'],     'rm': ['-MORE-',  'CommandMode' ], 'r?': ['CONFIRM', 'CommandMode'],
        \  '!': ['SHELL',   'CommandMode'],      't': ['TERMINAL', 'CommandMode']}

  let g:ro_sym  = "RO"
  let g:ma_sym  = "✗"
  let g:mod_sym = "◇"
  let g:ff_map  = { "unix": "␊", "mac": "␍", "dos": "␍␊" }

  " newMode may be a value as returned by mode(1) or the name of a highlight group
  " Note: setting highlight groups while computing the status line may cause the
  " startup screen to disappear. See: https://github.com/powerline/powerline/issues/250
  fun! s:updateStatusLineHighlight(newMode)
    execute 'hi! link CurrMode' get(g:mode_map, a:newMode, ["", a:newMode])[1]
    return 1
  endf

  " nr is always the number of the currently active window. In a %{} context, winnr()
  " always refers to the window to which the status line being drawn belongs. Since this
  " function is invoked in a %{} context, winnr() may be different from a:nr. We use this
  " fact to detect whether we are drawing in the active window or in an inactive window.
  fun! SetupStl(nr)
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
          \%#CurrMode#%{w:["lf_active"] ? "  " . get(g:mode_map, mode(1), [mode(1)])[0] . (&paste ? " PASTE " : " ") : ""}%*
          \ %{winnr()}  %t %{&modified ? g:mod_sym : " "} %{&modifiable ? (&readonly ? g:ro_sym : "  ") : g:ma_sym}
          \ %<%{w:["lf_winwd"] < 80 ? (w:["lf_winwd"] < 50 ? "" : expand("%:p:h:t")) : expand("%:p:h")}
          \ %=
          \ %w %{&ft} %{w:["lf_winwd"] < 80 ? "" : " " . (strlen(&fenc) ? &fenc : &enc) . (&bomb ? ",BOM " : " ")
          \ . get(g:ff_map, &ff, "?") . (&expandtab ? " ˽ " : " ⇥ ") . &tabstop}
          \ %#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? ""
          \ : printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))) : ""}
          \%#Warnings#%{w:["lf_active"] ? get(b:, "lf_stl_warnings", "") : ""}%*'
  endf
" }}
" Tabline {{
  fun! BuildTabLabel(nr)
    return " " . a:nr
          \ . (empty(filter(tabpagebuflist(a:nr), 'getbufvar(v:val, "&modified")')) ? " " : " " . g:mod_sym . " ")
          \ . (get(extend(t:, {
          \ "tablabel": fnamemodify(bufname(tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1]), ":t")
          \ }), "tablabel") == "" ? "[No Name]" : get(t:, "tablabel")) . "  "
  endf

  fun! BuildTabLine()
    return join(map(
          \   range(1, tabpagenr('$')),
          \   '(v:val == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#") . "%".v:val."T %{BuildTabLabel(".v:val.")}"'
          \ ), '')
          \ . "%#TabLineFill#%T%=⌘ %<%{getcwd()}  " . (tabpagenr('$') > 1 ? "%999X✕ " : "")
  endf

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

  fun! s:customizeTheme()
    let g:lf_cached_mode = ""  " Force updating highlight groups
    if strlen(get(g:, "colors_name", "")) " Inspired by AfterColors plugin
      execute "runtime after/themes/" . g:colors_name . ".vim"
    endif
  endf

  fun! s:enableStatusLine()
    if exists("g:default_stl") | return | endif
    augroup lf_warnings
      autocmd!
      autocmd BufReadPost,BufWritePost * call <sid>updateWarnings()
    augroup END
    set noshowmode " Do not show the current mode because it is displayed in the status line
    set noruler
    let g:default_stl = &statusline
    let g:default_tal = &tabline
    set statusline=%!BuildStatusLine(winnr()) " winnr() is always the number of the *active* window
    set tabline=%!BuildTabLine()
  endf

  fun! s:disableStatusLine()
    if !exists("g:default_stl") | return | endif
    let &tabline = g:default_tal
    let &statusline = g:default_stl
    unlet g:default_tal
    unlet g:default_stl
    set ruler
    set showmode
    autocmd! lf_warnings
    augroup! lf_warnings
  endf

  " Update trailing space and mixed indent warnings for the current buffer.
  " See http://got-ravings.blogspot.it/2008/10/vim-pr0n-statusline-whitespace-flags.html
  fun! s:updateWarnings()
    if exists('b:lf_no_warnings')
      unlet! b:lf_stl_warnings
      return
    endif
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
    keeppatterns %s/\s\+$//e
    call winrestview(l:winview) " Restore window state
    call s:updateWarnings()
    redraw  " See :h :echo-redraw
    echomsg 'Trailing space removed!'
  endf

  " }}
" Commands (plugins excluded) {{
  " Grep search
  command! -nargs=* -complete=file Grep call lf_find#grep(<q-args>)

  " Generate tags in the directory of the current buffer
  command! -nargs=* -complete=shellcmd Ctags call lf_tags#ctags(<q-args>)

  " Custom status line
  command! -nargs=0 EnableStatusLine call <sid>enableStatusLine()
  command! -nargs=0 DisableStatusLine call <sid>disableStatusLine()

  " Find all occurrences of a pattern in the current buffer
  command! -nargs=1 Search call lf_find#buffer(<q-args>)

  " Find all occurrences of a pattern in all open buffers
  command! -nargs=1 SearchAll call lf_find#all_buffers(<q-args>)

  " Fuzzy search for files inside a directory (default: working dir).
  command! -nargs=? -complete=dir FindFile call lf_find#file(<q-args>)

  " Spotlight search (macOS only)
  command! -nargs=* -complete=shellcmd Spotlight call lf_find#arglist('mdfind '.<q-args>)

  " See :h :DiffOrig
  command! -nargs=0 DiffOrig call lf_text#diff_orig()

  " Execute an arbitrary (non-interactive) Git command and show the output in a new buffer.
  command! -complete=shellcmd -nargs=+ Git call lf_git#exec(<q-args>, "B")

  " Execute an external command and show the output in a new buffer
  command! -complete=shellcmd -nargs=+ Shell call lf_job#to_buffer(<q-args>, "B")

  " Execute a Vim command and send the output to a new scratch buffer
  command! -complete=command -nargs=+ CmdBuffer call lf_buffers#cmd(<q-args>)

  " Send text to a terminal
  command! BindTerminal call lf_terminal#open()
  command! REPLSendLine call lf_terminal#send([getline('.')])
  command! -range=% REPLSendSelection call lf_terminal#send(lf_text#selection(<line1>,<line2>))

  " Set the tab width for the current buffer
  command! -nargs=1 TabWidth call lf_text#set_tab_width(<q-args>)

  " Clean up old undo files
  command! -nargs=0 CleanUpUndoFiles !find ~/.vim/tmp/undo -type f -mtime +100d \! -name '.gitignore' -delete
" }}
" Key mappings (plugins excluded) {{
  " Use space as alternative leader
  map <space> <leader>
  set pastetoggle=<f9>
  " Avoid entering Ex mode
  nnoremap Q <nop>
  nnoremap gQ <nop>
  " Change to the directory of the current file
  nnoremap <silent> cd :<c-u>cd %:h \| pwd<cr>
  " Square bracket mappings (many of them inspired by Unimpaired)
  nnoremap <silent> [<space> :<c-u>put!=repeat(nr2char(10),v:count1)<cr>']+1
  nnoremap <silent> ]<space> :<c-u>put=repeat(nr2char(10),v:count1)<cr>'[-1
  nnoremap <silent> [a :<c-u><c-r>=v:count1<cr>prev<cr>
  nnoremap <silent> ]a :<c-u><c-r>=v:count1<cr>next<cr>
  nnoremap <silent> ]b :<c-u><c-r>=v:count1<cr>bn<cr>
  nnoremap <silent> [b :<c-u><c-r>=v:count1<cr>bp<cr>
  nnoremap <silent> ]l :<c-u><c-r>=v:count1<cr>lnext<cr>zz
  nnoremap <silent> [l :<c-u><c-r>=v:count1<cr>lprevious<cr>zz
  nnoremap <silent> ]L :<c-u>llast<cr>zz
  nnoremap <silent> [L :<c-u>lfirst<cr>zz
  nnoremap <silent> ]n :<c-u><c-r>=v:count1<cr>/\v^[<\|=>]{7}<cr>
  nnoremap <silent> [n :<c-u><c-r>=v:count1<cr>?\v^[<\|=>]{7}<cr>
  nnoremap <silent> ]q :<c-u><c-r>=v:count1<cr>cnext<cr>zz
  nnoremap <silent> [q :<c-u><c-r>=v:count1<cr>cprevious<cr>zz
  nnoremap <silent> ]Q :<c-u>clast<cr>zz
  nnoremap <silent> [Q :<c-u>cfirst<cr>zz
  nnoremap <silent> ]t :<c-u><c-r>=v:count1<cr>tn<cr>
  nnoremap <silent> [t :<c-u><c-r>=v:count1<cr>tp<cr>
  " Window navigation
  nnoremap <leader>1 1<c-w>w
  nnoremap <leader>2 2<c-w>w
  nnoremap <leader>3 3<c-w>w
  nnoremap <leader>4 4<c-w>w
  nnoremap <leader>5 5<c-w>w
  nnoremap <leader>6 6<c-w>w
  nnoremap <leader>7 7<c-w>w
  nnoremap <leader>8 8<c-w>w
  nnoremap <leader>9 9<c-w>w
  nnoremap <leader>0 10<c-w>w
  if &term =~# '^\%(tmux\|screen\)'
    nnoremap <silent> <a-h> :<c-u>call lf_tmux#navigate('h')<cr>
    nnoremap <silent> <a-j> :<c-u>call lf_tmux#navigate('j')<cr>
    nnoremap <silent> <a-k> :<c-u>call lf_tmux#navigate('k')<cr>
    nnoremap <silent> <a-l> :<c-u>call lf_tmux#navigate('l')<cr>
  else
    nnoremap <a-l> <c-w>l
    nnoremap <a-h> <c-w>h
    nnoremap <a-j> <c-w>j
    nnoremap <a-k> <c-w>k
  endif
  " Allow using alt in macOS without enabling “Use Option as Meta key”
  nmap ¬ <a-l>
  nmap ˙ <a-h>
  nmap ∆ <a-j>
  nmap ˚ <a-k>
  " Easier copy/pasting to/from OS clipboard
  nnoremap <leader>y "*y
  vnoremap <leader>y "*y
  nnoremap <leader>Y "*Y
  nnoremap <leader>p "*p
  vnoremap <leader>p "*p
  nnoremap <leader>P "*P
  vnoremap <leader>P "*P
  " Make
  nnoremap <silent> <leader>m :<c-u>update<cr>:silent make<bar>redraw!<bar>bo cwindow<cr>
  " Terminal
  nnoremap <silent> <leader>x :<c-u>REPLSendLine<cr>+
  vnoremap <silent> <leader>x :<c-u>REPLSendSelection<cr>
  " Change the contrast level for themes that support it.
  nmap     <silent> <leader>- :<c-u>call lf_theme#contrast(-v:count1)<cr>
  nmap     <silent> <leader>+ :<c-u>call lf_theme#contrast(v:count1)<cr>
  " Tab width
  nnoremap <silent> <leader>] :<c-u>call lf_text#set_tab_width(&tabstop + v:count1)<cr>
  nnoremap <silent> <leader>[ :<c-u>call lf_text#set_tab_width(&tabstop - v:count1)<cr>
  " Buffers
  nnoremap <silent> <leader>ba :<c-u>call lf_tags#alt_file()<cr>
  nnoremap          <leader>bb :<c-u>ls<cr>:b<space>
  nnoremap          <leader>bd :<c-u>bd<cr>
  nnoremap          <leader>bD :<c-u>bd!<cr>
  nnoremap          <leader>b<c-d> :<c-u>confirm 1,.-bdelete<cr>:confirm .+,$bdelete<cr>
  nnoremap          <leader>bm :<c-u>CmdBuffer messages<cr>
  nnoremap          <leader>bn :<c-u>enew<cr>
  nnoremap          <leader>bs :<c-u>vnew +setlocal\ buftype=nofile\ bufhidden=wipe\ noswapfile<cr>
  nnoremap          <leader>bw :<c-u>setlocal readonly!<cr>
  " Cscope
  nnoremap <silent> <leader>ca :<c-u>cs find a <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <silent> <leader>cc :<c-u>cs find c <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <silent> <leader>cd :<c-u>cs find d <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <silent> <leader>ce :<c-u>cs find e <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <silent> <leader>cf :<c-u>cs find f <c-r>=fnameescape(expand("<cfile>"))<cr><cr>
  nnoremap <silent> <leader>cg :<c-u>cs find g <c-r>=fnameescape(expand("<cword>"))<cr><cr>
  nnoremap <silent> <leader>ci :<c-u>cs find i ^<c-r>=fnameescape(expand("<cfile>"))<cr><cr>:bo cwindow<cr>
  nnoremap <silent> <leader>cs :<c-u>cs find s <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <silent> <leader>ct :<c-u>cs find t <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  " Edit
  nnoremap <silent> <leader>es :<c-u>call <sid>removeTrailingSpace()<cr>
  vnoremap <silent> <leader>eU :<c-u>s/\%V\v<(.)(\w*)/\u\1\L\2/g<cr>
  inoremap ( ()<c-g>U<left>
  inoremap [ []<c-g>U<left>
  inoremap { {}<c-g>U<left>
  inoremap <expr> ) strpart(getline('.'), col('.') - 1, 1) ==# ')' ? "\<right>" :  ')'
  inoremap <expr> ] strpart(getline('.'), col('.') - 1, 1) ==# ']' ? "\<right>" :  ']'
  inoremap <expr> } strpart(getline('.'), col('.') - 1, 1) ==# '}' ? "\<right>" :  '}'
  " Files
  nnoremap          <leader>ff :<c-u>FindFile<cr>
  nnoremap          <leader>fr :<c-u>filter /\c/ browse oldfiles<c-f>3gE<c-c>
  nnoremap <silent> <leader>fw :<c-u>update<cr>
  nnoremap <silent> <leader>w  :<c-u>update<cr>
  nnoremap          <leader>fW :<c-u>w !sudo tee % >/dev/null<cr>
  nnoremap          <leader>fz :<c-u>call lf_find#arglist(v:oldfiles)<cr>
  " Git
  nnoremap <silent> <leader>gb :<c-u>call lf_git#blame()<cr>
  nnoremap <silent> <leader>gc :<c-u>call lf_git#commit()<cr>
  nnoremap <silent> <leader>gd :<c-u>call lf_git#diff()<cr>
  nnoremap <silent> <leader>gl :<c-u>Git log --oneline -- %:t<cr>
  nnoremap <silent> <leader>gp :<c-u>echomsg 'Pushing...'<cr>:call lf_git#push()<cr>
  nnoremap <silent> <leader>gs :<c-u>call lf_git#status()<cr>
  nnoremap <silent> <leader>gt :<c-u>call lf_git#three_way_diff()<cr>
  " Options
  nnoremap <silent> <leader>ob :<c-u>call lf_theme#toggle_bg_color()<cr>
  nnoremap <silent> <leader>oc :<c-u>setlocal cursorline!<cr>
  nnoremap          <leader>od :<c-r>=&diff ? 'diffoff' : 'diffthis'<cr><cr>
  nnoremap <silent> <leader>oh :<c-u>set hlsearch! \| set hlsearch?<cr>
  nnoremap <silent> <leader>oH :<c-u>call lf_theme#toggle_hi_info()<cr>
  nnoremap <silent> <leader>oi :<c-u>set ignorecase! \| set ignorecase?<cr>
  nnoremap <silent> <leader>ok :<c-u>let &l:scrolloff = (&l:scrolloff == 999) ? g:default_scrolloff : 999<cr>
  nnoremap <silent> <leader>ol :<c-u>setlocal list!<cr>
  nnoremap <silent> <leader>on :<c-u>setlocal number!<cr>
  nnoremap <silent> <leader>or :<c-u>setlocal relativenumber!<cr>
  nnoremap <silent> <leader>os :<c-u>setlocal spell! \| set spell?<cr>
  nnoremap <silent> <leader>ot :<c-u>setlocal expandtab!<cr>
  nnoremap <silent> <leader>ow :<c-u>call lf_text#toggleWrap()<cr>
  " Appeareance (view)
  nnoremap <silent> <leader>vc :<c-u>call lf_find#colorscheme()<cr>
  nnoremap <silent> <leader>vs :<c-u>let &laststatus=2-&laststatus<cr>
  " }}
" GUI {{
  if has('gui_running')
    let s:linespace=2
    set guifont=SF\ Mono:h11
    set guioptions=gm
    set guicursor=n-v-c:block,i-o-r-ci-cr:ver20
    let &linespace=s:linespace
    set transparency=0
    cd $HOME/Documents/Outbox
    nnoremap <leader>fz :<c-u>CtrlPMRUFiles<cr>
  endif
" }}
" Plugins {{
  " Disabled Vim Plugins {{
    let g:loaded_getscriptPlugin = 1
    let g:loaded_gzip = 1
    let g:loaded_logiPat = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_tarPlugin = 1
    let g:loaded_vimballPlugin = 1
    let g:loaded_zipPlugin = 1
  " }}
  " clang_complete {{
    let g:clang_library_path = '/usr/local/opt/llvm/lib/libclang.dylib'
    let g:clang_user_options = '-std=c++14'
    let g:clang_complete_auto = 1
    augroup lf_cpp  " Lazily load clang_complete
      autocmd!
      autocmd BufReadPre *.c,*.cpp,*.h,*.hpp packadd clang_complete | autocmd! lf_cpp | augroup! lf_cpp | endif
    augroup END
  " }}
  " CtrlP {{
    let g:ctrlp_cmd = 'CtrlPBuffer'
    if executable('rg')
      let g:ctrlp_user_command = 'rg %s --files --maxdepth=10 --color=never'
      let g:ctrlp_use_caching = 0
    endif
    let g:ctrlp_buftag_types = {
          \ 'context':  '--language-force=context',
          \ 'markdown': '--language-force=markdown',
          \ 'sql':      '--language-force=pgsql',
          \ 'tex':      '--language-force=latex',
          \ 'mp':       '--language-force=metapost',
          \ 'mf':       '--language-force=metapost'
          \ }
    let g:ctrlp_types = ['fil', 'buf', 'mru']
    let g:ctrlp_extensions = ['buffertag', 'tag', 'quickfix']
    let g:ctrlp_open_multiple_files = '2vjr'
    let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
    let s:ctrlp_section_map = {"mru files": "recent"}
    let g:ctrlp_status_func = {'main': 'CtrlP_Main', 'prog': 'CtrlP_Progress'}
    let g:ctrlp_switch_buffer = 0

    fun! CtrlP_Main(...) " See :h ctrlp_status_func
      let l:section = get(s:ctrlp_section_map, a:5, a:5)
      return a:1 ==# 'prt'
            \ ? '%#InsertMode# '.l:section.' %* %<'.getcwd().' %= %#InsertMode#'.(a:3?' regex ':' match ').a:2.' %*'
            \ : '%#VisualMode# '.l:section.' %* %<'.getcwd().' %= %#VisualMode# select %*'
    endf

    fun! CtrlP_Progress(...)
      return '%#Warnings# '.a:1.' %* %= %<%#Warnings# '.getcwd().' %*'
    endf
  " }}
  " Dirvish {{
    nmap <leader>d <plug>(dirvish_up)
    nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
  " }}
  " Easy Align {{
    xmap <leader>ea <plug>(EasyAlign)
    nmap <leader>ea <plug>(EasyAlign)
  " }}
  " Goyo {{
    " Toggle distraction-free mode
    nnoremap <silent> <leader>vf :Goyo<cr>

    fun! s:goyoEnter()
      if has('gui_running')
        "set fullscreen
        set linespace=5
      elseif g:colors_name =~# '^solarized8'
        let g:limelight_conceal_ctermfg = (&background ==# 'dark') ? '10' : '14'
      endif
      set scrolloff=999 " Keep the edited line vertically centered
      silent call lf_text#enableSoftWrap()
      set noshowcmd
      Limelight
    endf

    fun! s:goyoLeave()
      if has('gui_running')
        "set nofullscreen
        let &linespace=s:linespace
      endif
      set showcmd
      silent call lf_text#disableSoftWrap()
      let &scrolloff=g:default_scrolloff
      Limelight!
    endf

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
    let g:markdown_folding = 1
  " }}
  " MetaPost (Vim) {{
    let g:mp_metafun_macros = 1
  " }}
  " MUcomplete {{
    inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
    inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
    inoremap <expr> <cr> mucomplete#popup_exit("\<cr>")
    nnoremap <silent> <leader>oa :<c-u>MUcompleteAutoToggle<cr>
  " }}
  " Show Marks {{
    fun! s:toggleShowMarks()
      if exists('b:showmarks')
        NoShowMarks
      else
        DoShowMarks
      endif
    endf
    nnoremap <silent> <leader>om :<c-u>call <sid>toggleShowMarks()<cr>
  " }}
  " Sneak {{
    let g:sneak#streak = 1
    let g:sneak#use_ic_scs = 1 " Match according to ignorecase and smartcase
  " }}
  " SQL (Vim) {{
    let g:sql_type_default = 'pgsql'
    let g:omni_sql_default_compl_type = 'syntax'
  " }}
  " Tagbar {{
    fun! TagbarStatusLine(current, sort, fname, flags, ...) abort
      return (a:current ? '%#NormalMode# Tagbar %* ' : '%#StatusLineNC# Tagbar ') . a:fname
    endf

    " Toggle tag bar
    nnoremap <silent> <leader>vt :if !exists("g:loaded_tagbar")<bar>packadd tagbar<bar>endif<cr>:TagbarToggle<cr>
    let g:tagbar_autofocus = 1
    let g:tagbar_iconchars = ['▸', '▾']
    let g:tagbar_status_func = 'TagbarStatusLine'

    " My Ctags file is at https://github.com/lifepillar/dotfiles
    let g:tagbar_type_sql = {
          \ 'ctagstype': 'pgsql',
          \ 'kinds': [
          \ 'f:functions',
          \ 'T:triggers',
          \ 't:tables',
          \ 'V:views',
          \ 'i:indexes',
          \ 'r:rules',
          \ 'd:types',
          \ 'S:sequences',
          \ 's:schemas',
          \ 'D:databases'
          \ ],
          \ 'sort': 0
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
    let g:tagbar_type_context = {
          \ 'ctagstype': 'context',
          \ 'kinds': [
          \ 'p:parts',
          \ 'c:chapters',
          \ 's:sections',
          \ 'S:slides'
          \ ],
          \ 'sort': 0
          \ }
    let g:tagbar_type_mp = {
          \ 'ctagstype': 'metapost',
          \ 'kinds': [
          \ 'c:characters',
          \ 'f:figures',
          \ 'v:vardef',
          \ 'd:def',
          \ 'p:primarydef',
          \ 's:secondarydef',
          \ 't:tertiarydef',
          \ 'C:testcases',
          \ 'T:tests'
          \ ],
          \ 'sort': 0
          \ }
    let g:tagbar_type_mf = g:tagbar_type_mp
  " }}
  " Undotree {{
    let g:undotree_WindowLayout = 2
    let g:undotree_SplitWidth = 40
    let g:undotree_SetFocusWhenToggle = 1
    let g:undotree_TreeNodeShape = '◦'
    nnoremap <silent> <leader>vu :<c-u>if !exists("g:loaded_undotree")<bar>packadd undotree<bar>endif<cr>:UndotreeToggle<cr>
  " }}
  " 2HTML (Vim) {{
    let g:html_pre_wrap=1
    let g:html_use_encoding="UTF-8"
    let g:html_font=["Consolas", "Menlo"]
  " }}
" }}
" Themes {{
  " Gruvbox {{
    let g:gruvbox_invert_selection = 0
    let g:gruvbox_italic = 1
  " }}
  " Seoul256 {{
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255
  " }}
  " Solarized 8 {{
    let g:solarized_statusline = 'low'
    let g:solarized_term_italics = 1
  " }}
  " WWDC16 {{
    let g:wwdc16_term_italics = 1
    let g:wwdc16_term_trans_bg = 1
  " }}
  " WWDC17 {{
    let g:wwdc17_term_italics = 1
  " }}
" }}
" NeoVim {{
  if has('nvim')
    language en_US.UTF-8
    let g:terminal_scrollback_buffer_size = 10000
    set shada=!,'1000,<50,s10,h  " Override viminfo setting
    " Use alt-arrows in the command line (see above)
    cmap <a-b> <s-left>
    cmap <a-f> <s-right>
  endif
" }}
" Init {{
  let g:LargeFile = 20*1024*1024

  EnableStatusLine

  if !has('packages') " Use Pathogen as a fallback
    runtime pack/bundle/opt/pathogen/autoload/pathogen.vim " Load Pathogen
    let g:pathogen_blacklist = ['tagbar', 'undotree']
    execute pathogen#infect('pack/bundle/start/{}', 'pack/my/start/{}', 'pack/my/opt/{}', 'pack/bundle/opt/{}', 'pack/themes/opt/{}')
    command! -nargs=1 -complete=customlist,lf_loader#complete LoadPlugin call lf_loader#loadPlugin(<q-args>) " Load a blacklisted plugin
  endif

  " Local settings
  let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/vimrc_local'
  if filereadable(s:vimrc_local)
    execute 'source' s:vimrc_local
  else
    colorscheme wwdc16
  endif
" }}
