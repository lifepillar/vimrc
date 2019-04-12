" Modeline and Notes {{
" vim: set sw=2 ts=2 sts=0 et fmr={{,}} fcs=vert\:| fdm=marker fdt=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" - To override the settings of a color scheme, create a file
"   after/colors/<theme name>.vim It will be automatically loaded after the
"   color scheme is activated.
"
" - For UTF-8 symbols to be displayed correctly (e.g., in the status line),
"   you may need to check "Set locale environment variables on startup" in
"   Terminal.app's preferences, or "Set locale variables automatically" in
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
  set encoding=utf-8
  scriptencoding utf-8
  set nobomb
  set fileformats=unix,mac,dos
  if has('langmap') && exists('+langremap') | set nolangremap | endif
  set timeoutlen=5000
  set ttimeout
  set ttimeoutlen=10  " This must be a low value for <esc>-key not to be confused with an <a-…> mapping
  set ttyfast
  set mouse=a
  if has('nvim')
    " NeoVim {{
    language en_US.UTF-8
    let g:terminal_scrollback_buffer_size = 10000
    set shada=!,'1000,<50,s10,h  " Override viminfo setting
    " Use alt-arrows in the command line (see :help map-alt-keys)
    cmap <a-b> <s-left>
    cmap <a-f> <s-right>
    " }}
  else
    " Vim {{
    set viminfo=!,'300,<10000,s10,h,n~/.vim/viminfo
    " See :set termcap, :h t_ku, :h :set-termcap, and http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
    " For terminal mappings, see Key Mappings section
    set <s-left>=b  " There's a literal Esc (^[) here and below (it may be invisible, e.g., in GitHub)
    set <s-right>=f
    set <a-h>=h
    set <a-j>=j
    set <a-k>=k
    set <a-l>=l
    if $TERM =~# '^\%(tmux\|screen\)'
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
    " }}
  endif
  set updatetime=500 " Trigger CursorHold event after half a second
  syntax enable
  filetype on " Enable file type detection
  filetype plugin on " Enable loading the plugin files for specific file types
  filetype indent on " Load indent files for specific file types
  set autoread " Re-read file if it is changed by an external program
  set hidden " Allow buffer switching without saving
  " Consolidate temporary files into a central spot
  set backupdir=~/.vim/tmp/backup
  set directory=~/.vim/tmp/swap
  set undofile " Enable persistent undo
  set undodir=~/.vim/tmp/undo
  set undolevels=1000 " Maximum number of changes that can be undone
  set undoreload=10000 " Maximum number of lines to save for undo on a buffer reload
" }}
" Editing {{
  set autoindent " Use indentation of the first-line when reflowing a paragraph
  set shiftround " Round indent to multiple of shiftwidth (applies to < and >)
  set backspace=indent,eol,start " Intuitive backspacing in insert mode
  set whichwrap=b,~,<,>,[,],h,l " More intuitive arrow movements
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
  set incsearch " Search as you type
  set ignorecase " Case-insensitive search by default
  set infercase " Smart case when doing keyword completion
  set smartcase " Use case-sensitive search if there is a capital letter in the search expression
  if executable('rg')
    set grepprg=rg\ -i\ --vimgrep
  endif
  set grepformat^=%f:%l:%c:%m
  set keywordprg=:help " Get help for word under cursor by pressing K
  set completeopt=menuone,noselect
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
  if has('termguicolors') && $COLORTERM ==# 'truecolor'
    let &t_8f = "\<esc>[38;2;%lu;%lu;%lum" " Needed in tmux
    let &t_8b = "\<esc>[48;2;%lu;%lu;%lum" " Ditto
    set termguicolors
  endif
  let g:default_scrolloff = 2
  let &scrolloff=g:default_scrolloff " Keep some context when scrolling
  set sidescrolloff=5 " Ditto, but for horizontal scrolling
  set display=lastline
  " Get more information from ctrl-g:
  nnoremap <c-g> 2<c-g>
  " Show block cursor in Normal mode and line cursor in Insert mode
  " (use odd numbers for blinking cursor):
  let &t_ti.="\e[2 q"
  let &t_SI.="\e[6 q"
  let &t_SR.="\e[4 q"
  let &t_EI.="\e[2 q"
  let &t_te.="\e[0 q"
  set notitle " Do not set the terminal title
  set number " Turn line numbering on
  set relativenumber " Display line numbers relative to the line with the cursor
  set nowrap " Don't wrap lines by default
  set linebreak " If wrapping is enabled, wrap at word boundaries
  set laststatus=2 " Always show status line
  set showtabline=2 " Always show the tab bar
  set cmdheight=2 " Increase space for command line
  set shortmess+=Icm " No intro, suppress ins-completion messages, use [+] instead of [Modified]
  set showcmd " Show (partial) command in the last line of the screen
  set diffopt+=vertical " Diff in vertical mode
  set listchars=tab:▸\ ,trail:∙,space:∙,eol:¬,nbsp:▪,precedes:⟨,extends:⟩  " Invisible characters
  let &showbreak='└ '
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
" }}
" Autocommands {{
  augroup lf_autocmds
    autocmd!
    " Hook for overriding a theme's default
    autocmd ColorScheme * call <sid>customizeTheme()
    " If a file is large, disable syntax highlighting and other stuff
    autocmd BufReadPre *
          \ let s = getfsize(expand("<afile>")) |
          \ if s > g:LargeFile || s == -2 |
          \   call lf_buffer#large(fnamemodify(expand("<afile>"), ":p")) |
          \ endif
    " On opening a file, jump to the last known cursor position (see :h line())
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
          \   exe "normal! g`\"" |
          \ endif
    " Less intrusive swap prompt
    autocmd SwapExists * call lf_buffer#swap_exists(expand("<afile>"))

    if exists('##CmdlineEnter') " See :h incsearch
      autocmd CmdlineEnter * :set hlsearch
      autocmd CmdlineLeave * :set nohlsearch
    endif

    autocmd TerminalOpen * set nonumber norelativenumber signcolumn=no
  augroup END
" }}
" Status line {{
  " See :h mode()
  let g:mode_map = {
        \ 'n': ['N', 'NormalMode' ], 'i': ['I', 'InsertMode' ],      'R': ['R', 'ReplaceMode'],
        \ 'v': ['V', 'VisualMode' ], 'V': ['V', 'VisualMode' ], "\<c-v>": ['V', 'VisualMode' ],
        \ 's': ['S', 'VisualMode' ], 'S': ['S', 'VisualMode' ], "\<c-s>": ['S', 'VisualMode' ],
        \ 'c': ['C','CommandMode'],  'r': ['P', 'CommandMode'],      't': ['T','CommandMode'],
        \ '!': ['!',  'CommandMode']}

  " newMode may be a value as returned by mode() or the name of a highlight group
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
            \ : (mode() ==# get(g:, "lf_cached_mode", "")
              \ ? 1
              \ : s:updateStatusLineHighlight(get(extend(g:, { "lf_cached_mode": mode() }), "lf_cached_mode"))
              \ ),
          \ "lf_winwd": winwidth(winnr())
          \ }), "", "")
  endf

  " Build the status line the way I want - no fat light plugins!
  fun! BuildStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"] ? "  " . get(g:mode_map, mode(), [mode()])[0] . (&paste ? " PASTE " : " ") : ""}%*
          \ %{(w:["lf_active"] ? "" : "   ") . winnr()} %{&modified ? "◦" : " "} %t (%n) %{&modifiable ? (&readonly ? "▪" : " ") : "✗"}
          \ %<%{empty(&buftype) ? (w:["lf_winwd"] < 80 ? (w:["lf_winwd"] < 50 ? "" : expand("%:p:h:t")) : expand("%:p:~:h")) : ""}
          \ %=
          \ %a %w %{&ft} %{w:["lf_winwd"] < 80 ? "" : " " . (strlen(&fenc) ? &fenc : &enc) . (&bomb ? ",BOM " : " ")
          \ . &ff . (&expandtab ? "" : " ⇥ ")} %l:%v %P
          \ %#Warnings#%{w:["lf_active"] ? get(b:, "lf_stl_warnings", "") : ""}%*'
  endf
" }}
" Tabline {{
  fun! BuildTabLabel(nr, active)
    return (a:active ? '●' : a:nr).' '.fnamemodify(bufname(tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1]), ":t:s/^$/[No Name]/").' '
  endf

  fun! BuildTabLine()
    return (tabpagenr('$') == 1 ? '' : join(map(
          \   range(1, tabpagenr('$')),
          \   '(v:val == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#") . "%".v:val."T %{BuildTabLabel(".v:val.",".(v:val == tabpagenr()).")}"'
          \ ), ''))
          \ . "%#TabLineFill#%T%=⌘ %<%{&columns < 100 ? fnamemodify(getcwd(), ':t') : getcwd()} " . (tabpagenr('$') > 1 ? "%999X✕ " : "")
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
      autocmd BufReadPost,BufWritePost * call <sid>update_warnings()
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
  fun! s:update_warnings()
    if exists('b:lf_no_warnings')
      unlet! b:lf_stl_warnings
      return
    endif
    if exists('b:lf_large_file')
      let b:lf_stl_warnings = ' Large file '
      return
    endif
    let l:trail  = search('\s$',       'cnw')
    let l:spaces = search('^\s\{-} ',  'cnw')
    let l:tabs   = search('^\s\{-}\t', 'cnw')
    if l:trail || (l:spaces && l:tabs)
      let b:lf_stl_warnings = ' '
            \ . (l:trail            ? 'Trailing space ('.l:trail.') '           : '')
            \ . (l:spaces && l:tabs ? 'Mixed indent ('.l:spaces.'/'.l:tabs.') ' : '')
    else
      unlet! b:lf_stl_warnings
    endif
  endf

  " Delete trailing white space.
  fun! s:removeTrailingSpace()
    let l:winview = winsaveview() " Save window state
    keeppatterns %s/\s\+$//e
    call winrestview(l:winview) " Restore window state
    call s:update_warnings()
    redraw  " See :h :echo-redraw
    echomsg 'Trailing space removed!'
  endf
" }}
" Commands (plugins excluded) {{
  " Grep search
  command! -nargs=* -complete=file Grep call lf_find#grep(<q-args>)

  " Generate tags and cscope db in the directory of the current buffer
  command! -nargs=* -complete=shellcmd Ctags call lf_tags#ctags(<q-args>)
  command! -nargs=* -complete=shellcmd Cscope call lf_tags#cscope(<q-args>)

  " Custom status line
  command! -nargs=0 EnableStatusLine call <sid>enableStatusLine()
  command! -nargs=0 DisableStatusLine call <sid>disableStatusLine()

  " Find all occurrences of a pattern in the current buffer
  command! -nargs=1 Search call lf_find#in_buffer(<q-args>)

  " Find all occurrences of a pattern in all open buffers
  command! -nargs=1 SearchAll call lf_find#in_all_buffers(<q-args>)

  " Fuzzy search for files inside a directory (default: working dir).
  command! -nargs=? -complete=dir FindFile call lf_find#file(<q-args>)

  " Spotlight search (macOS only)
  command! -nargs=* -complete=shellcmd Spotlight call lf_find#arglist('mdfind '.<q-args>)

  " See :h :DiffOrig
  command! -nargs=0 -bar DiffOrig call lf_text#diff_orig()

  " Execute a Vim command and send the output to a new scratch buffer
  command! -complete=command -nargs=+ VimCmd call lf_run#vim_cmd(<q-args>)

  " Open a terminal and "bind" it to the current buffer (see \x mappings below)
  command! BindTerminal call lf_terminal#open()

  " Get/set the tab width for the current buffer
  command! -nargs=? TabWidth call lf_text#tab_width(<args>)

  " Clean up old undo files
  command! -nargs=0 CleanUpUndoFiles !find ~/.vim/tmp/undo -type f -mtime +100d \! -name '.gitignore' -delete
" }}
" Key mappings (plugins excluded) {{
  " Use space as alternative leader
  map <space> <leader>
  set pastetoggle=<f9>
  " Avoid entering Ex mode by pressing gQ (Q is remapped below)
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
  nnoremap <silent> ]n /\v^[<\|=>]{7}<cr>
  nnoremap <silent> [n ?\v^[<\|=>]{7}<cr>
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
  if $TERM =~# '^\%(tmux\|screen\)'
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
  " Insert snippet
  inoremap <silent> … <c-r>=lf_text#expand_snippet()<cr>
  " Make
  nnoremap <silent> <leader>m :<c-u>update<cr>:silent make<bar>redraw!<bar>bo cwindow<cr>
  " Terminal
  nnoremap <silent> <leader>x :<c-u>call lf_terminal#send([getline('.')])<cr>
  vnoremap <silent> <leader>x :<c-u>call lf_terminal#send(lf_text#selection())<cr>
  if has('terminal')
    " Use Alt+arrows to jump between words
    tnoremap <s-left> <esc>b
    tnoremap <s-right> <esc>f
    " Jump to another window directly from terminal mode
    tnoremap ¬ <c-w>l
    tnoremap ˙ <c-w>h
    tnoremap ∆ <c-w>j
    tnoremap ˚ <c-w>k
    tnoremap <c-w>1 <c-w>:1wincmd w<cr>
    tnoremap <c-w>2 <c-w>:2wincmd w<cr>
    tnoremap <c-w>3 <c-w>:3wincmd w<cr>
    tnoremap <c-w>4 <c-w>:4wincmd w<cr>
    tnoremap <c-w>5 <c-w>:5wincmd w<cr>
    tnoremap <c-w>6 <c-w>:6wincmd w<cr>
    tnoremap <c-w>7 <c-w>:7wincmd w<cr>
    tnoremap <c-w>8 <c-w>:8wincmd w<cr>
    tnoremap <c-w>9 <c-w>:9wincmd w<cr>
    tnoremap <c-w>0 <c-w>:10wincmd w<cr>
    " Allow scrolling with the mouse when in Terminal mode
    tnoremap <silent> <expr> <scrollwheelup> lf_terminal#enter_normal_mode()
    tnoremap <silent> <f8> <c-w>:call lf_terminal#toggle_scrollwheelup()<cr>
  endif
  " Tab width
  nnoremap <silent> <leader>] :<c-u>call lf_text#tab_width(&tabstop + v:count1)<cr>
  nnoremap <silent> <leader>[ :<c-u>call lf_text#tab_width(&tabstop - v:count1)<cr>
  " Comment/uncomment (overrides Q, so we avoid entering Ex mode by mistake)
  nnoremap <silent>  Q :set opfunc=lf_text#toggle_comment<cr>g@
  vnoremap <silent>  Q :<c-u>call lf_text#toggle_comment(visualmode(), 1)<cr>
  " Save buffer
  nnoremap <silent> <leader>w :<c-u>update<cr>
  nnoremap          <leader>W :<c-u>w !sudo tee % >/dev/null<cr>
  " Buffers
  nnoremap <silent> <leader>ba :<c-u>call lf_tags#alt_file()<cr>
  nnoremap          <leader>bb :<c-u>ls<cr>:b
  nnoremap <silent>      <c-p> :<c-u>call lf_find#buffer(0)<cr>
  nnoremap <silent> <leader>bd :<c-u>bd<cr>
  nnoremap <silent> <leader>bD :<c-u>bd!<cr>
  nnoremap <silent> <leader>b<c-d> :<c-u>call lf_buffer#delete_others()<cr>
  nnoremap <silent> <leader>bm :<c-u>VimCmd messages<cr>
  nnoremap <silent> <leader>bn :<c-u>enew<cr>
  nnoremap <silent> <leader>bs :<c-u>vnew +setlocal\ buftype=nofile\ bufhidden=wipe\ noswapfile<cr>
  nnoremap <silent> <leader>br :<c-u>setlocal readonly!<cr>
  nnoremap <silent> <leader>bt :<c-u>call lf_find#buffer_tag()<cr>
  nnoremap <silent> <leader>bw :<c-u>bw<cr>
  nnoremap <silent> <leader>bW :<c-u>bw!<cr>
  nnoremap <silent> <leader>b<c-w> :<c-u>call lf_buffer#wipe_others()<cr>
  " Edit
  nnoremap <silent> <leader>es :<c-u>call <sid>removeTrailingSpace()<cr>
  vnoremap <silent> <leader>eU :<c-u>s/\%V\v<(.)(\w*)/\u\1\L\2/g<cr>
  " Find/filter
  nnoremap <silent> <leader>ff :<c-u>FindFile<cr>
  nnoremap <silent> <c-n>      :<c-u>call lf_find#arglist(v:oldfiles)<cr>
  nmap     <silent> <leader>fr <c-n>
  nnoremap <silent> <leader>fz :<c-u>call lf_find#arglist_fuzzy(v:oldfiles)<cr>
  " Quickfix/Location list
  nnoremap <silent> <leader>fl :<c-u>call lf_find#in_loclist(0)<cr>
  nnoremap <silent> <leader>fq :<c-u>call lf_find#in_qflist()<cr>
  " Fossil
  nnoremap <silent> <leader>fd :<c-u>call lf_fossil#diff()<cr>
  nnoremap <silent> <leader>fk :<c-u>call lf_terminal#run(['fossil', 'commit'])<cr>
  nnoremap <silent> <leader>fp :<c-u>call lf_terminal#run(['fossil', 'sync'])<cr>
  nnoremap <silent> <leader>fs :<c-u>call lf_run#cmd(['fossil', 'status'])<cr>
  nnoremap <silent> <leader>ft :<c-u>call lf_fossil#three_way_diff()<cr>
  " Git
  nnoremap <silent> <leader>gd :<c-u>call lf_git#diff()<cr>
  nnoremap <silent> <leader>gk :<c-u>call lf_terminal#run(['git', 'commit'])<cr>
  nnoremap <silent> <leader>gp :<c-u>call lf_terminal#run(['git', 'push'])<cr>
  nnoremap <silent> <leader>gs :<c-u>call lf_run#cmd(['git', 'status'])<cr>
  nnoremap <silent> <leader>gt :<c-u>call lf_git#three_way_diff()<cr>
  " Options
  nnoremap <silent> <leader>oc :<c-u>setlocal cursorline!<cr>
  nnoremap          <leader>od :<c-r>=&diff ? 'diffoff' : 'diffthis'<cr><cr>
  nnoremap <silent> <leader>oh :<c-u>set hlsearch! \| set hlsearch?<cr>
  nnoremap <silent> <leader>oH :<c-u>call colortemplate#syn#toggle()<cr>
  nnoremap <silent> <leader>oi :<c-u>set ignorecase! \| set ignorecase?<cr>
  nnoremap <silent> <leader>ok :<c-u>let &l:scrolloff = (&l:scrolloff == 999) ? g:default_scrolloff : 999<cr>
  nnoremap <silent> <leader>ol :<c-u>setlocal list!<cr>
  nnoremap <silent> <leader>on :<c-u>setlocal number!<cr>
  nnoremap <silent> <leader>or :<c-u>setlocal relativenumber!<cr>
  nnoremap <silent> <leader>os :<c-u>setlocal spell! \| set spell?<cr>
  nnoremap <silent> <leader>ot :<c-u>setlocal expandtab!<cr>
  nnoremap <silent> <leader>ow :<c-u>call lf_text#toggle_wrap()<cr>
  " View/toggle
  nnoremap <silent> <leader>vc :<c-u>call lf_find#colorscheme()<cr>
  nnoremap <silent> <leader>vm :<c-u>marks<cr>
  nnoremap <silent> <leader>vs :<c-u>let &laststatus=2-&laststatus<cr>
  nnoremap <silent> <leader>vl :<c-u>botright lopen<cr>
  nnoremap <silent> <leader>vq :<c-u>botright copen<cr>
  " }}
" GUI {{
  if has('gui_running')
    let s:linespace=2
    set guifont=SF\ Mono\ Regular:h10
    set guioptions=gm
    set guicursor=n-c:blinkwait100-blinkon600-blinkoff600
    set guicursor+=v:blinkwait100-blinkon400-blinkoff400
    set guicursor+=i-o-ci:ver15-blinkwait100-blinkon600-blinkoff600
    set guicursor+=r-cr:hor10-blinkoff0
    set sidescrolloff=0
    let &linespace=s:linespace
    if !has('ios')
      set transparency=0
      let $TERM='xterm-256color'
      tnoremap <a-left> <esc>b
      tnoremap <a-right> <esc>f
    endif
  endif
" }}
" Plugins {{
  " Disabled Vim Plugins {{
    let g:loaded_getscriptPlugin = 1
    let g:loaded_gzip = 1
    let g:loaded_logiPat = 1
    let g:loaded_rrhelper = 1
    let g:loaded_tarPlugin = 1
    let g:loaded_vimballPlugin = 1
    let g:loaded_zipPlugin = 1
  " }}
  " clang_complete {{
    let g:clang_library_path = '/usr/local/opt/llvm/lib/libclang.dylib'
    let g:clang_user_options = '-std=c++14'
    let g:clang_complete_auto = 0
    fun! s:clang_complete_lazy_load()
      packadd clang_complete
      autocmd! lf_cpp
      augroup! lf_cpp
    endf
    augroup lf_cpp
      autocmd!
      autocmd BufReadPre *.c,*.cpp,*.h,*.hpp call <sid>clang_complete_lazy_load()
    augroup END
  " }}
  " Dirvish/Netrw {{
    if has('ios') " Use Netrw
      let g:loaded_dirvish = 1
      let g:netrw_banner = 0
      let g:netrw_bufsettings = 'noswf noma nomod nu rnu nowrap ro nobl'
      let g:netrw_sort_options = 'i'
      nnoremap <silent> <leader>d :<c-u>Ex<cr>
    else " Use Dirvish
      let g:loaded_netrwPlugin = 1
      nmap <leader>d <plug>(dirvish_up)
      nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
    endif
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
      endif
      set scrolloff=999 " Keep the edited line vertically centered
      silent call lf_text#enable_soft_wrap()
      set noshowcmd
      Limelight
    endf

    fun! s:goyoLeave()
      if has('gui_running')
        "set nofullscreen
        let &linespace=s:linespace
      endif
      set showcmd
      silent call lf_text#disable_soft_wrap()
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
  " }}
  " MetaPost (Vim) {{
    let g:mp_metafun_macros = 1
  " }}
  " MUcomplete {{
    nnoremap <silent> <leader>oa :<c-u>MUcompleteAutoToggle<cr>
    imap <expr> <up> mucomplete#extend_bwd("\<up>")
    imap <expr> <down> mucomplete#extend_fwd("\<down>")
    inoremap <expr> <cr> pumvisible() ? "<c-y><cr>" : "<cr>"
  " }}
  " Sneak {{
    nmap <c-s> <plug>Sneak_s
    nmap gs <plug>Sneak_S
    let g:sneak#label = 1
    let g:sneak#use_ic_scs = 1 " Match according to ignorecase and smartcase
  " }}
  " SQL (Vim) {{
    let g:sql_type_default = 'pgsql'
    let g:omni_sql_default_compl_type = 'syntax'
  " }}
  " Tagbar {{
    fun! TagbarStatusLine(current, sort, fname, flags, ...) abort
      return (a:current ? '%#NormalMode# Tagbar %* ' : '%#StatusLineNC# Tagbar  ') . winnr() . ' ' . a:fname
    endf

    " Toggle tag bar
    nnoremap <silent> <leader>vt :<c-u>if !exists("g:loaded_tagbar")<bar>packadd tagbar<bar>endif<cr>:TagbarToggle<cr>
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
    let g:tagbar_type_rmd = {
          \ 'ctagstype': 'rmarkdown',
          \ 'kinds': [
          \ 's:sections',
          \ 'r:snippets',
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
  if has('ios')
    let g:wwdc16_no_italics = 1
    let g:wwdc17_no_italics = 1
  else
    let g:gruvbox_italic = 1
    let g:gruvbox_italicize_strings = 1
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255
    let g:solarized_statusline = 'low'
    let g:solarized_term_italics = 1
  endif
" }}
" Init {{
  let g:LargeFile = 20*1024*1024 " 20MB

  EnableStatusLine

  if !has('packages') " Use Pathogen as a fallback
    runtime pack/bundle/opt/pathogen/autoload/pathogen.vim " Load Pathogen
    execute pathogen#infect('pack/{}/start/{}', 'pack/{}/opt/{}')
  endif

  " Local settings
  let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/vimrc_local'
  if filereadable(s:vimrc_local)
    execute 'source' s:vimrc_local
  else
    colorscheme wwdc16
  endif
" }}
