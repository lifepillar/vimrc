" Modeline and Notes {{
" vim: set sw=2 ts=2 sts=0 et fmr={{,}} fdl=0 fdm=marker fdt=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" ---
" For UTF-8 symbols to be displayed correctly (e.g., in the status line), you
" may need to check "Set locale environment variables on startup" in OS X
" Terminal.app's preferences, or "Set locale variables automatically" in
" iTerm's Terminal settings.
"
" If UTF-8 symbols are not displayed in remote sessions (that is, when you run
" Vim on a remote machine to which you are connected via SSH), make sure that the
" following line is *not* commented in the client's /etc/ssh_config:
"
"     SendEnv LANG LC_*
"
" As a last resort, you may set LC_ALL and LANG manually on the server; e.g., put
" these in your remote machine's .bash_profile:
"
"     export LC_ALL=en_US.UTF-8
"     export LANG=en_US.UTF-8
"
" ---
" Spell files can be downloaded from ftp://ftp.vim.org/pub/vim/runtime/spell/
" and put inside .vim/spell.
" }}
" Environment {{
  set nocompatible " Must be first line.
  " See http://stackoverflow.com/questions/18321538/vim-error-e474-invalid-argument-listchars-tab-trail
  set encoding=utf-8
  scriptencoding utf-8
  set termencoding=utf-8
  set nobomb
  set fileformats=unix,mac,dos
  set timeoutlen=2000 " How long to wait to recognize multikey input (ms)
  set ttimeoutlen=0 " Faster feedback in status line when returning to normal mode
  set ttyfast
  set updatetime=1000 " Trigger CursorHold event after one second
  syntax enable
  filetype on " Enable file type detection.
  filetype plugin on " Enable loading the plugin files for specific file types.
  filetype indent on " Load indent files for specific file types.
  runtime bundle/pathogen/autoload/pathogen.vim " Load Pathogen.
  execute pathogen#infect()
  set sessionoptions-=options " See FAQ at https://github.com/tpope/vim-pathogen.
  set autoread " Re-read file if it is changed by an external program.
  set hidden " Allow buffer switching without saving.
  set history=1000 " Keep a longer history.
  " Files and directories to ignore
  set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.o,*.obj,*.so,*.swp,*.zip
  let g:netrw_list_hide= ',\.DS_Store,Icon\?,\.dmg$,^\.git/,\.pyc$,\.o$,\.obj$,\.so$,\.swp$,\.zip$'
  " Consolidate temporary files in a central spot
  set backupdir=~/.vim/tmp
  set directory=~/.vim/tmp
  set viminfo+=n~/.vim/viminfo
  set undofile
  set undodir=~/.vim/tmp
  set undolevels=1000 " Maximum number of changes that can be undone.
  set undoreload=10000 " Maximum number lines to save for undo on a buffer reload.
  set nobackup " Do not keep a backup copy of a file.
  set nowritebackup " Do not write temporary backup files.
  set noswapfile " Do not create swap files.
" }}
" Helper functions {{
  fun! s:warningMessage(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
  endf

  " Set the tab width in the current buffer (see also http://vim.wikia.com/wiki/Indenting_source_code).
  fun! s:setLocalTabWidth(w)
    let l:twd = a:w > 0 ? a:w : 1 " Disallow non-positive width
    " For the following assignment, see :help let-&.
    " See also http://stackoverflow.com/questions/12170606/how-to-set-numeric-variables-in-vim-functions.
    let &l:tabstop=l:twd
    let &l:shiftwidth=l:twd
    let &l:softtabstop=l:twd
  endf

  " Set the tab width globally.
  fun! s:setGlobalTabWidth(w)
    let l:twd = a:w > 0 ? a:w : 1 " Disallow non-positive width
    let &tabstop=l:twd
    let &shiftwidth=l:twd
    let &softtabstop=l:twd
  endf

  " Delete trailing white space.
  fun! s:removeTrailingSpace()
    let l:winview = winsaveview() " Save window state
    %s/\s\+$//ge
    call winrestview(l:winview) " Restore window state
    echomsg 'Trailing space removed!'
  endf

  fun! s:softWrap()
    setlocal wrap
    map <buffer> j gj
    map <buffer> k gk
    echomsg "Soft wrap enabled"
  endf

  fun! s:dontSoftWrap()
    setlocal nowrap
    if mapcheck("j") != ""
      unmap <buffer> j
      unmap <buffer> k
    endif
    echomsg "Soft wrap disabled"
  endf

  " Toggle soft-wrapped text in the current buffer.
  fun! s:toggleWrap()
    if &l:wrap
      call s:dontSoftWrap()
    else
      call s:softWrap()
    endif
  endf

  command! -nargs=0 ToggleWrap call <sid>toggleWrap()

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

  " Return the real background color of the given highlight group.
  fun! s:getBackground(hl)
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
    execute 'hi! '. a:hl . (has("gui_running") || (has("termtruecolor") && guicolors == 1) ?
          \ ' guifg='   . s:getBackground(a:fgHl) . ' guibg='   . s:getBackground(a:bgHl) :
          \ ' ctermfg=' . s:getBackground(a:fgHl) . ' ctermbg=' . s:getBackground(a:bgHl))
  endf

  fun! s:enablePatchedFont()
    let g:left_sep_sym = "\ue0b0"
    let g:right_sep_sym = "\ue0b2"
    let g:lalt_sep_sym = "\ue0b1"
    let g:ralt_sep_sym = "\ue0b3"
    let g:ro_sym = "\ue0a2"
    let g:ma_sym = "⚔"
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
    let g:ro_sym = "✗"
    let g:ma_sym = "⚔"
    let g:mod_sym = "◇"
    let g:linecol_sym = ""
    let g:branch_sym = ""
    let g:pad = ""
  endf

  " Update trailing space and mixed indent warnings for the current buffer.
  " See http://got-ravings.blogspot.it/2008/10/vim-pr0n-statusline-whitespace-flags.html
  fun! s:updateWarnings()
    let l:winview = winsaveview() " Save window state
    call cursor(1,1) " Start search from the beginning of the file
    let l:trail = search('\s$', 'nw')
    let l:spaces = search('\v^\s* ', 'nw')
    let l:tabs = search('\v^\s*\t', 'nw')
    if l:trail != 0
      let b:stl_warnings = '  Trailing space ('.trail.') '
      if l:spaces != 0 && l:tabs != 0
        let b:stl_warnings .= 'Mixed indent ('.spaces.'/'.l:tabs.') '
      endif
    elseif l:spaces != 0 && l:tabs != 0
      let b:stl_warnings = '  Mixed indent ('.spaces.'/'.l:tabs.') '
    else
      unlet! b:stl_warnings
    endif
    call winrestview(l:winview) " Restore window state
  endf

  fun! s:cheatsheet()
    botright vert 40sview ${HOME}/.vim/cheatsheet.txt
    setlocal bufhidden=wipe nobuflisted noswapfile nowrap
    nnoremap <silent> <buffer> <tab> <c-w><c-w>
    nnoremap <silent> <buffer> q <c-w>c
  endf

  " An outliner in less than 20 lines of code! The format is compatible with
  " VimOutliner (just in case we decide to use it): lines starting with : are
  " used for notes (indent one level wrt to the owning node). Promote,
  " demote, move, (un)fold and reformat with standard commands (plus mappings
  " defined below). Do not leave blank lines between nodes.
  fun! s:outlinerFoldingRule(n)
    return getline(a:n) =~ '^\s*:' ?
          \ 20 : indent(a:n) < indent(a:n+1) ?
          \ ('>'.(1+indent(a:n)/&l:tabstop)) : (indent(a:n)/&l:tabstop)
  endf

  fun! s:enableOutliner()
    setlocal autoindent
    setlocal formatoptions=tcqrnjo
    setlocal comments=fb:*,fb:-,b::
    setlocal textwidth=80
    setlocal foldmethod=expr
    setlocal foldexpr=s:outlinerFoldingRule(v:lnum)
    setlocal foldtext=getline(v:foldstart)
    setlocal foldlevel=2
    " Full display with collapsed notes:
    nnoremap <buffer> <silent> <leader>n :set foldlevel=19<cr>
    TabWidth 4
  endf
" }}
" Editing {{
  set backspace=indent,eol,start " Intuitive backspacing in insert mode.
  set whichwrap+=<,>,[,],h,l " More intuitive arrow movements.
  set scrolloff=999 " Keep the edited line vertically centered.
  " set clipboard=unnamed " Use system clipboard by default.
  " Smooth scrolling that works both in terminal and in MacVim
  nnoremap <silent> <c-u> :call <sid>smoothScroll(1)<cr>
  nnoremap <silent> <c-d> :call <sid>smoothScroll(0)<cr>
  " Scroll the viewport faster.
  nnoremap <c-e> <c-e><c-e>
  nnoremap <c-y> <c-y><c-y>
  set showmatch " Show matching brackets/parenthesis
  set matchtime=2 " show matching bracket for 0.2 seconds
  set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
  set splitright " Puts new vsplit windows to the right of the current
  set splitbelow " Puts new split windows to the bottom of the current
  set formatoptions+=j " Remove extra comment when joining lines
  " Load matchit.vim, but only if the user hasn't installed a newer version.
  if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim " Enable % to go to matching keyword/tag.
  endif
  " Shift left/right repeatedly
  vnoremap > >gv
  vnoremap < <gv
  " Use soft tabs by default
  set expandtab
  call s:setGlobalTabWidth(2)

  " Set the tab width for the current buffer.
  command! -nargs=1 TabWidth call <sid>setLocalTabWidth(<q-args>)

  " Save file with sudo.
  command! -nargs=0  WW :w !sudo tee % >/dev/null
" }}
" Find, replace, and auto-complete {{
  set incsearch " Search as you type.
  set ignorecase " Case-insensitive search by default.
  set smartcase " Use case-sensitive search if there is a capital letter in the search expression.
  set infercase " Smart keyword completion
  set wildmenu " Show possible matches when autocompleting.
  set wildignorecase " Ignore case when completing file names and directories.

  " Find all occurrences of a pattern in a file.
  fun! s:findAll(pattern)
    if getbufvar(winbufnr(winnr()), "&ft") ==# "qf"
      call s:warningMessage("Cannot search the quickfix window")
      return
    endif
    try
      silent noautocmd execute "lvimgrep /" . a:pattern . "/gj " . fnameescape(expand("%"))
    catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
      call s:warningmessage("no match")
    endtry
    lwindow
  endf

  " Find all occurrences of a pattern in all open files.
  fun! s:multiFind(pattern)
    " Get the list of open files
    let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'fnameescape(bufname(v:val))')
    try
      silent noautocmd execute "vimgrep /" . a:pattern . "/gj " . join(l:files)
    catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
      call s:warningmessage("no match")
    endtry
    cwindow
  endf

  " Find all in current buffer.
  command! -nargs=1 FindAll call s:findAll(<q-args>)

  " Find all in all open buffers.
  command! -nargs=1 MultiFind call s:multiFind(<q-args>)
" }}
" Shell {{
  let s:winpos_map = {
        \ "T": "to new",  "t": "abo new", "B": "bo new",  "b": "bel new",
        \ "L": "to vnew", "l": "abo vnew", "R": "bo vnew", "r": "bel vnew"
        \ }

  " Run an external command and display its output in a new buffer.
  "
  " cmdline: the command to be executed;
  " pos: a letter specifying the position of the output window (see s:winpos_map).
  "
  " See http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
  " See also https://groups.google.com/forum/#!topic/vim_use/4ZejMpt7TeU
  fun! s:runShellCommand(cmdline, pos) abort
    let l:cmd = ""
    for l:part in split(a:cmdline, ' ')
      if l:part =~ '\v^[%#<]'
        let l:expanded_part = expand(l:part)
        let l:cmd .= ' ' . (l:expanded_part == "" ? l:part : shellescape(l:expanded_part))
      else
        let l:cmd .= ' ' . l:part
      endif
    endfor
    execute get(s:winpos_map, a:pos, "bo new")
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    execute '%!'. l:cmd
    setlocal nomodifiable
    nnoremap <silent> <buffer> <tab> <c-w><c-w>
    nnoremap <silent> <buffer> q <c-w>c
    " Uncomment the following line for debugging
    " echomsg cmd
    1
  endf

  " Execute an external command and show the output in a new buffer.
  command! -complete=shellcmd -nargs=+ Shell call s:runShellCommand(<q-args>, "B")
  command! -complete=shellcmd -nargs=+ ShellBot call s:runShellCommand(<q-args>, "B")
  command! -complete=shellcmd -nargs=+ ShellRight call s:runShellCommand(<q-args>, "R")
  command! -complete=shellcmd -nargs=+ ShellLeft call s:runShellCommand(<q-args>, "L")
  command! -complete=shellcmd -nargs=+ ShellTop call s:runShellCommand(<q-args>, "T")

" }}
" Git {{
  " Execute a non-interactive Git command in the directory containing
  " the file of the current buffer, and send the output to a new buffer.
  " args: a string of arguments for the commmand
  " pos: a letter specifying the position of the new buffer (see s:runShellCommand()).
  fun! s:git(args, pos)
    call s:runShellCommand("git -C %:p:h " . a:args, a:pos)
  endf

  " Show a vertical diff (use <c-w> K to arrange horizontally)
  " between the current buffer and its last committed version.
  fun! s:gitDiff()
    let l:ft = getbufvar("%", '&ft') " Get the file type
    call s:git("show HEAD:./" . shellescape(expand("%:t")), 'r')
    let &l:filetype = l:ft
    file HEAD
    autocmd BufWinLeave <buffer> diffoff!
    diffthis
    wincmd p
    diffthis
  endf

  " Show a three-way diff. Useful for fixing merge conflicts.
  " This assumes that the current file is the working copy, of course.
  fun! s:git3WayDiff()
    let l:filename = shellescape(expand("%:t"))
    let l:ft = getbufvar("%", "&ft") " Get the file type
    " Show the version from the current branch on the left
    call s:git("show :2:./" . l:filename, "l")
    let &l:filetype = l:ft
    file OURS
    autocmd BufWinLeave <buffer> diffoff!
    diffthis
    wincmd p
    " Show version from the other branch on the right
    call s:git("show :3:./" . l:filename, "r")
    let &l:filetype = l:ft
    file OTHER
    autocmd BufWinLeave <buffer> diffoff!
    diffthis
    wincmd p
    diffthis
  endf

  " Execute an arbitrary (non-interactive) Git command and show the output in a new buffer.
  command! -complete=shellcmd -nargs=+ Git call <sid>git(<q-args>, "B")

  " Three-way diff.
  command! -nargs=0 Conflicts call <sid>git3WayDiff()
" }}
" Key mappings (plugins excluded) {{
  " A handy cheat sheet ;)
  nnoremap <silent> <leader>? :call <sid>cheatsheet()<cr>
  " Enable outline mode for the current buffer
  nnoremap <silent> <leader>O :call <sid>enableOutliner()<cr>
  " Open file browser in the directory of the current buffer
  nnoremap <silent> <leader>e :Ex<cr>
  " Toggle between hard tabs and soft tabs in the current buffer
  nnoremap <silent> cot :setlocal invexpandtab<cr>
  " Increase tab width by one in the current buffer
  nnoremap <silent> <leader>] :call <sid>setLocalTabWidth(&tabstop + 1)<cr>
  " Decrease tab width by one in the current buffer
  nnoremap <silent> <leader>[ :call <sid>setLocalTabWidth(&tabstop - 1)<cr>
  " Toggle paste mode
  nnoremap <silent> cop :setlocal paste!<cr>
  " Remove trailing space globally
  nnoremap <silent> <leader>S :call <sid>removeTrailingSpace()<cr>
  " Capitalize words in selected text (see h gU)
  vnoremap <silent> <leader>U :<c-u>s/\v<(.)(\w*)/\u\1\L\2/g<cr>
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
  " Compare buffer with HEAD
  nnoremap <silent> <leader>gd :call <sid>gitDiff()<cr>
  " Git status
  nnoremap <silent> <leader>gs :Git status<cr>:setlocal ft=gitcommit<cr>
  " Git commit
  nnoremap <silent> <leader>gc :!git -C '%:p:h' commit<cr>
  " Show the revision history for the current file (use :Git log for the full log)
  nnoremap <silent> <leader>gl :Git log --oneline -- %<cr>
  " Add files/patches to the index
  nnoremap <silent> <leader>ga :!git -C '%:p:h' add -p '%:p'<cr>
  " Git push
  nnoremap <silent> <leader>gp :!git -C '%:p:h' push<cr>
  " Use bindings in command mode similar to those used by the shell (see also :h cmdline-editing)
  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-p> <up>
  cnoremap <c-n> <down>
  " cnoremap <c-b> <left>
  " cnoremap <c-f> <right>
  " Allow using alt-arrows to jump over words in OS X, as in Terminal.app
  cnoremap <esc>b <s-left>
  cnoremap <esc>f <s-right>
" }}
" Appearance {{
  set title " Set the terminal title.
  set number " Turn line numbering on.
  set relativenumber " Display line numbers relative to the line with the cursor.
  set nowrap " Don't wrap lines by default.
  set linebreak " If wrapping is enabled, wrap at word boundaries.
  " set colorcolumn=80 " Show page guide at column 80.
  set laststatus=2 " Always show status line.
  set shortmess-=l " Don't use abbreviations for 'characters', 'lines'
  set shortmess-=r " Don't use abbreviations for 'readonly'
  set showcmd " Show (partial) command in the last line of the screen.
  set noshowmode " Do not show current mode because it is already shown in status line
  set diffopt+=vertical " Diff in vertical mode
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:• " Symbols to use for invisible characters (see also http://stackoverflow.com/questions/20962204/vimrc-getting-e474-invalid-argument-listchars-tab-no-matter-what-i-do).
  " Resize windows when the terminal window size changes
  " (from http://vimrcfu.com/snippet/186):
  autocmd VimResized * :wincmd =
" }}
" MacVim {{
  if has('gui_macvim')
    set guifont=Monaco:h14
    set guioptions-=aP " Do not use system clipboard by default
    set guioptions-=T  " No toolbar
    set guioptions-=lL " No left scrollbar
    set guicursor=n-v-c:ver20 " Use a thin vertical bar as the cursor
    set transparency=4
  endif
" }}
" Themes {{
  " To override the settings of a theme, define a function called
  " s:customizeTheme_<theme_name>. Such function will be automatically called
  " after the color scheme is activated.

  fun! s:customizeTheme()
    hi! link netrwMarkFile DiffAdd
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
    set fillchars=vert:\ ,fold:\·
    if exists('g:colors_name')
      let l:fn = 's:customizeTheme_' . substitute(g:colors_name, '[-]', '_', 'g')
      if exists('*' . l:fn)
        call eval(l:fn . '()')
      endif
    endif
  endf

  autocmd ColorScheme * call <sid>customizeTheme()

  " For themes that have dark and light variants with different names (e.g.,
  " seoul256/seoul256_light), define corresponding
  " s:toggleBackground_<theme_name>() functions that change the color scheme.
  fun! s:toggleBackgroundColor()
    if exists('g:colors_name')
      let l:fn = 's:toggleBackground_' . substitute(g:colors_name, '[-]', '_', 'g')
      if exists('*' . l:fn)
        call eval(l:fn . '()')
        return
      endif
    endif
    let g:lf_cached_mode = ""  " Force updating status line highlight groups
    let &background = (&background == 'dark') ? 'light' : 'dark'
  endf

  command! -nargs=0 ToggleBackgroundColor call <sid>toggleBackgroundColor()

  command! -nargs=0 EnablePatchedFont call <sid>enablePatchedFont()
  command! -nargs=0 DisablePatchedFont call <sid>disablePatchedFont()

  " Solarized {{
    let g:solarized_bold = 1
    let g:solarized_underline = 0

    fun! s:customizeTheme_solarized()
      hi clear Folded
      hi clear SignColumn
      hi clear VertSplit
      hi clear Search
      hi! link VertSplit LineNr
      hi! link Search VisualMode
      hi ErrorMsg ctermbg=1 ctermfg=15 guibg=#dc322f guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      call s:setTabLineSepGroups()
      if &background ==# 'dark'
        hi MatchParen ctermbg=0 ctermfg=14 guibg=#073642 guifg=#93a1a1 term=bold cterm=bold gui=bold
        let g:limelight_conceal_ctermfg = 10
      else
        hi MatchParen ctermbg=7 ctermfg=0 guibg=#eee8d5 guifg=#073642 term=bold cterm=bold gui=bold
        let g:limelight_conceal_ctermfg = 14
      endif

      if &background ==# 'dark'
        hi StatusLine ctermbg=7 ctermfg=10 guibg=#eee8d5 guifg=#586e75 term=reverse cterm=reverse gui=reverse
        hi StatusLineNC ctermbg=10 ctermfg=0 guibg=#586e75 guifg=#073642 term=reverse cterm=reverse gui=reverse
        hi NormalMode ctermbg=14 ctermfg=15 guibg=#93a1a1 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      else
        hi StatusLine ctermbg=7 ctermfg=14 guibg=#eee8d5 guifg=#93a1a1 term=reverse cterm=reverse gui=reverse
        hi StatusLineNC ctermbg=14 ctermfg=7 guibg=#93a1a1 guifg=#eee8d5 term=reverse cterm=reverse gui=reverse
        hi NormalMode ctermbg=10 ctermfg=15 guibg=#586e75 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      endif
      hi InsertMode ctermbg=6 ctermfg=15 guibg=#2aa198 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      hi ReplaceMode ctermbg=9 ctermfg=15 guibg=#cb4b16 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      hi VisualMode ctermbg=5 ctermfg=15 guibg=#d33682 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      hi CommandMode ctermbg=5 ctermfg=15 guibg=#d33682 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
    endf
    " }}
  " Gruvbox {{
    fun! s:customizeTheme_gruvbox()
    endf
  " }}
  " Jellybeans {{
    fun! s:customizeTheme_jellybeans()
    endf
  " }}
  " PaperColor {{
    fun! s:customizeTheme_PaperColor()
      set fillchars=vert:\|,fold:\·
      hi! link Search VisualMode
      if &background ==# 'light'
        hi InsertMode ctermbg=31 ctermfg=255 guibg=#3e999f guifg=#f5f5f5 term=NONE cterm=NONE gui=NONE
        hi ReplaceMode ctermbg=166 ctermfg=255 guibg=#d75f00 guifg=#f5f5f5 term=NONE cterm=NONE gui=NONE
      endif
    endf
  " }}
  " Pencil {{
  fun! s:customizeTheme_pencil()
    if &background ==# 'dark'
      hi NormalMode ctermbg=245 ctermfg=7 guibg=#636363 guifg=#c6c6c6 term=NONE cterm=NONE gui=NONE
      hi InsertMode ctermbg=24 ctermfg=7 guibg=#005f87 guifg=#c6c6c6 term=NONE cterm=NONE gui=NONE
      hi ReplaceMode ctermbg=166 ctermfg=7 guibg=#d75f5f guifg=#c6c6c6 term=NONE cterm=NONE gui=NONE
      hi Warnings ctermbg=160 ctermfg=7 guibg=#c30771 guifg=#c6c6c6 term=NONE cterm=NONE gui=NONE
    else
      hi NormalMode ctermbg=241 ctermfg=254 guibg=#545454 guifg=#d9d9d9 term=NONE cterm=NONE gui=NONE
      hi InsertMode ctermbg=24 ctermfg=254 guibg=#005f87 guifg=#d9d9d9 term=NONE cterm=NONE gui=NONE
      hi ReplaceMode ctermbg=166 ctermfg=254 guibg=#d75f5f guifg=#d9d9d9 term=NONE cterm=NONE gui=NONE
      hi Warnings ctermbg=160 ctermfg=254 guibg=#c30771 guifg=#d9d9d9 term=NONE cterm=NONE gui=NONE
    endif
  endf
  " }}
  " Seoul256 {{
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255

    fun! s:toggleBackground_seoul256()
      colorscheme seoul256-light
    endf

    fun! s:toggleBackground_seoul256_light()
      colorscheme seoul256
    endf

    fun! s:customizeTheme_seoul256()
      hi! link VertSplit StatusLineNC
      hi! link NormalMode StatusLineNC
      hi! link InsertMode PmenuSbar
      hi! link ReplaceMode Search
      hi! link CommandMode DiffAdd
    endf

    fun! s:customizeTheme_seoul256_light()
      hi NormalMode ctermbg=239 ctermfg=187 guibg=#616161 guifg=#dfdebd term=NONE cterm=NONE gui=NONE
      hi InsertMode ctermbg=65 ctermfg=187 guibg=#719872 guifg=#fdf6e3 term=NONE cterm=NONE gui=NONE
      hi! link ReplaceMode WildMenu
      hi! link CommandMode DiffChange
    endf
  " }}
  " Tomorrow {{
    fun! s:toggleBackground_Tomorrow()
      colorscheme Tomorrow-Night-Eighties
    endf

    fun! s:toggleBackground_Tomorrow_Night_Eighties()
      colorscheme Tomorrow
    endf

    fun! s:customizeTheme_Tomorrow()
      hi! link NormalMode PmenuSel
      hi! link InsertMode DiffAdd
      hi! link CommandMode Search
    endf

    fun! s:customizeTheme_Tomorrow_Night_Eighties()
      call s:customizeTheme_Tomorrow()
    endf
  " }}
" }}
" Status line {{
  " See :h mode() (some of these are never used in the status line)
  let g:mode_map = {
        \ 'n':  ['NORMAL',  'NormalMode' ], 'no':     ['PENDING', 'NormalMode' ], 'v': ['VISUAL',  'VisualMode' ],
        \ 'V':  ['V-LINE',  'VisualMode' ], "\<c-v>": ['V-BLOCK', 'VisualMode' ], 's': ['SELECT',  'VisualMode' ],
        \ 'S':  ['S-LINE',  'VisualMode' ], "\<c-s>": ['S-BLOCK', 'VisualMode' ], 'i': ['INSERT',  'InsertMode' ],
        \ 'R':  ['REPLACE', 'ReplaceMode'], 'Rv':     ['REPLACE', 'ReplaceMode'], 'c': ['COMMAND', 'CommandMode'],
        \ 'cv': ['COMMAND', 'CommandMode'], 'ce':     ['COMMAND', 'CommandMode'], 'r': ['PROMPT',  'CommandMode'],
        \ 'rm': ['-MORE-',  'CommandMode'], 'r?':     ['CONFIRM', 'CommandMode'], '!': ['SHELL',   'CommandMode'] }

  let g:ff_map = { "unix": "␊ (Unix)", "mac": "␍ (Classic Mac)", "dos": "␍␊ (Windows)" }

  " newMode may be a value as returned by mode(1) or the name of a highlight group.
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
          \ "lf_active": winnr() != a:nr ? 0 : (
          \                mode(1) ==# get(g:, "lf_cached_mode", "") ? 1 :
          \                  s:updateStatusLineHighlight(
          \                    get(extend(g:, { "lf_cached_mode": mode(1) }), "lf_cached_mode")
          \                  )
          \                ),
          \ "lf_bufnr": winbufnr(winnr()),
          \ "lf_winwd": winwidth(winnr())
          \ }), "", "")
  endf

  " Build the status line the way I want - no fat light plugins!
  fun! BuildStatusLine(nr)
    return '%{SetupStl('.a:nr.')}
          \%#CurrMode#%{w:["lf_active"] ? "  " . get(g:mode_map, mode(1), ["?"])[0] . (&paste ? " PASTE " : " ") : ""}
          \%#SepMode#%{w:["lf_active"] ? g:left_sep_sym . " " : ""}%*
          \%{w:["lf_active"] ? ""  : "     "} %<%F
          \ %{getbufvar(w:["lf_bufnr"], "&modified") ? g:mod_sym : " "}
          \ %{getbufvar(w:["lf_bufnr"], "&modifiable") ? (getbufvar(w:["lf_bufnr"], "&readonly") ? g:ro_sym : "") : g:ma_sym}
          \ %=
          \ %{getbufvar(w:["lf_bufnr"], "&ft")}
          \ %{w:["lf_winwd"] < 80 ? "" : " "
          \ . getbufvar(w:["lf_bufnr"], "&fenc") . (getbufvar(w:["lf_bufnr"], "&bomb") ? ",BOM" : "") . " "
          \ . get(g:ff_map, getbufvar(w:["lf_bufnr"], "&ff"), "? (Unknown)") . " "
          \ . (getbufvar(w:["lf_bufnr"], "&expandtab") ? "˽ " : "⇥ ") . getbufvar(w:["lf_bufnr"], "&tabstop")}
          \ %#SepMode#%{w:["lf_active"] && w:["lf_winwd"] >= 60 ? g:right_sep_sym : ""}
          \%#CurrMode#%{w:["lf_active"] ? (w:["lf_winwd"] < 60 ? ""
          \ : g:pad . printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))) : ""}
          \%#Warnings#%{w:["lf_active"] && exists("b:stl_warnings") ? b:stl_warnings : ""}%*'
  endf

  fun! s:enableStatusLine()
    augroup warnings
      autocmd!
      autocmd BufReadPost,BufWritePost * call <sid>updateWarnings()
    augroup END
    let g:default_stl = &statusline
    set statusline=%!BuildStatusLine(winnr()) " In this context, winnr() is always the window number of the *active* window
  endf

  fun! s:disableStatusLine()
    let &statusline = g:default_stl
    augroup warnings
      autocmd!
    augroup END
    augroup! warnings
  endf

  command! -nargs=0 EnableStatusLine call <sid>enableStatusLine()
  command! -nargs=0 DisableStatusLine call <sid>disableStatusLine()
" }}
" Tabline {{
  " See :h tabline

  " Define the highlight groups for the separator symbols in the tabline.
  fun! s:setTabLineSepGroups()
    call s:setTransitionGroup("TabSepPreSel", "TabLine", "TabLineSel")
    call s:setTransitionGroup("TabSepSel", "TabLineSel", "TabLine")
    call s:setTransitionGroup("TabSepFill", "TabLine", "TabLineFill")
    call s:setTransitionGroup("TabSepSelFill", "TabLineSel", "TabLineFill")
    return s:getBackground("TabLine") == s:getBackground("TabLineFill")
  endf

  fun! BuildTabLabel(nr)
    return " " . a:nr
          \ . (empty(filter(tabpagebuflist(a:nr), 'getbufvar(v:val, "&modified")')) ? " " : " " . g:mod_sym . " ")
          \ . (get(extend(t:, {
          \ "tablabel": fnamemodify(bufname(tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1]), ":t")
          \ }), "tablabel") == "" ? "[No Name]" : get(t:, "tablabel")) . "  "
  endf

  fun! s:tabLineSeparator(n)
    return (a:n + 1 == tabpagenr() ?
        \ "%#TabSepPreSel#" . g:left_sep_sym :
        \ (a:n == tabpagenr() ?
          \ (a:n == tabpagenr('$') ?
          \ "%#TabSepSelFill#" . g:left_sep_sym :
          \ "%#TabSepSel#" . g:left_sep_sym
          \ ) :
          \ (a:n != tabpagenr('$') || s:two_color_tabline ?
            \ "%#TabSepSel#" . g:lalt_sep_sym :
            \ "%#TabSepFill#" . g:left_sep_sym
          \ )
        \ )
      \ )
  endf

  fun! BuildTabLine()
    return join(map(
          \ range(1, tabpagenr('$')),
          \ '(v:val == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#") . "%".v:val."T %{BuildTabLabel(".v:val.")}" . s:tabLineSeparator(v:val)'
          \), '') . "%#TabLineFill#%T" . (tabpagenr('$') > 1 ? "%=%999X✕ " : "")
  endf

  set tabline=%!BuildTabLine()
" }}
" Plugins {{
  " CtrlP {{
    " Open CtrlP in MRU mode by default
    let g:ctrlp_cmd = 'CtrlPMRU'
    let g:ctrlp_status_func = {
          \ 'main': 'CtrlP_Main',
          \ 'prog': 'CtrlP_Progress',
          \ }
    let g:ctrlp_extensions = ['funky', 'tag']

    " See https://gist.github.com/kien/1610859
    " Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
    "            a:1    a:2      a:3       a:4  a:5   a:6  a:7
    fun! CtrlP_Main(...)
      if a:1 ==# 'prt'
        call s:updateHighlightGroups("InsertMode")
        let g:lf_cached_mode = ""  " Force update of highlight groups when leaving CtrlP
        return '%#InsertMode# ' . a:5 . ' %#SepMode#%{g:left_sep_sym}%* '
              \ . getcwd() . ' %= %#SepMode#%{g:right_sep_sym}%#InsertMode#'
              \ . (a:3 ? ' regex ' : ' match ') . a:2 . ' %*'
      else
        call s:updateHighlightGroups("VisualMode")
        let g:lf_cached_mode = ""  " Ditto
        return '%#VisualMode# ' . a:5 . ' %#SepMode#%{g:left_sep_sym}%* '
              \ . getcwd() . ' %= %#SepMode#%{g:right_sep_sym}%#VisualMode# select %*'
      endif
    endf

    " Argument: len
    "           a:1
    fun! CtrlP_Progress(...)
      call s:updateHighlightGroups("Warnings")
      let g:lf_cached_mode = ""  " Ditto
      return '%#Warnings# ' . a:1 . ' %#SepMode#%{g:left_sep_sym}%* %= %#SepMode#%{g:right_sep_sym}%<%#Warnings# ' . getcwd() . ' %*'
    endf
  " }}
  " Easy Align {{
    vmap <enter> <plug>(EasyAlign)
  " }}
  " EasyMotion {{
    let g:EasyMotion_do_mapping = 0
    let g:EasyMotion_smartcase = 1
    map  <leader>/ <plug>(easymotion-sn)
    omap <leader>/ <plug>(easymotion-tn)
    nmap <leader>s <plug>(easymotion-s)
    omap <leader>s <plug>(easymotion-s)
  " }}
  " Goyo {{
    " Toggle distraction-free mode
    nnoremap <silent> <leader>f :Goyo<cr>
    fun! s:goyoEnter()
      if has('gui_macvim')
        "set fullscreen
        set guifont=Monaco:h14
        set linespace=7
        set guioptions-=r " hide right scrollbar
      endif
      call s:softWrap()
      set noshowcmd
      Limelight
    endf

    fun! s:goyoLeave()
      if has('gui_macvim')
        "set nofullscreen
        set guifont=Monaco:h14
        set linespace=0
        set guioptions+=r
      endif
      call s:dontSoftWrap()
      set showcmd
      Limelight!
      let g:lf_cached_mode = ""
    endf

    autocmd! User GoyoEnter
    autocmd! User GoyoLeave
    autocmd! User GoyoEnter nested call <sid>goyoEnter()
    autocmd! User GoyoLeave nested call <sid>goyoLeave()
  " }}
  " Ledger {{
    let g:ledger_maxwidth = 63
    let g:ledger_fillstring = ''
    " let g:ledger_detailed_first = 1
    let g:ledger_fold_blanks = 1
    let g:ledger_decimal_sep = ','
    let g:ledger_align_at = 60
    let g:ledger_default_commodity = 'EUR'
    let g:ledger_commodity_before = 0
    let g:ledger_commodity_sep = ' '
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
    nnoremap <silent> <leader>m :call <sid>toggleShowMarks()<cr>
    nnoremap ` :ShowMarksOnce<cr>`
  " }}
  " Tagbar {{
    fun! TagbarStatusLine(current, sort, fname, flags, ...) abort
      return a:current ?
            \ '%#NormalMode# Tagbar %#SepMode#%{g:left_sep_sym}%* ' . a:fname . ' %= '
              \ . '%#SepMode#%{g:tagbar_sort ? g:right_sep_sym : ""}%#NormalMode#'
              \ . (g:tagbar_sort ? ' By name ' : '') . '%*'
            \ :
            \ '%#StatusLineNC# Tagbar ' . a:fname
    endf

    " Toggle tag bar
    nnoremap <silent> <leader>t :TagbarToggle<cr>
    let g:tagbar_autofocus = 1
    let g:tagbar_autoclose = 1
    let g:tagbar_iconchars = ['▸', '▾']
    let g:tagbar_status_func = 'TagbarStatusLine'
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
" }}
" Init {{

  DisablePatchedFont
  EnableStatusLine

  " Extra settings.
  " If this file exists, it should at least define the color scheme.
  if filereadable($HOME . '/.vim/vimrc_extra.vim')
    execute 'source' $HOME . '/.vim/vimrc_extra.vim'
  else
    colorscheme solarized
  endif
" }}

