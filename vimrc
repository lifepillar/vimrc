" Modeline and Notes {{
" vim: set sw=3 ts=3 sts=0 noet tw=78 fo-=o foldmarker={{,}} foldlevel=0 foldmethod=marker foldtext=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" Remember to check "Set locale environment variables on startup" in OS X Terminal.app's preferences.
" (This is needed for UTF-8 symbols, e.g., in the status line, to be displayed correctly.)
" }}
" Environment {{
	set nocompatible " Must be first line.
	" See http://stackoverflow.com/questions/18321538/vim-error-e474-invalid-argument-listchars-tab-trail
	scriptencoding utf-8
	set encoding=utf-8
	set termencoding=utf-8
	set nobomb
	set fileformats=unix,mac,dos
	set ttimeoutlen=100 " Faster feedback in status line when returning to normal mode
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
	set wildignore+=.DS_Store,Icon\?,*.dmg,*.git,*.pyc,*.so,*.swp,*.zip
	let g:netrw_list_hide= '\.DS_Store,Icon\?,\.dmg$,\.git$,\.pyc$,\.so$,\.swp$,\.zip$'
	" Tree listing by default
	let g:netrw_liststyle=3
	" Consolidate temporary files in a central spot
	set backupdir=~/.vim/tmp
	set directory=~/.vim/tmp
	set viminfo+=n~/.vim/viminfo
	set undofile
	set undodir=~/.vim/tmp
	set undolevels=1000         " Maximum number of changes that can be undone.
	set undoreload=10000        " Maximum number lines to save for undo on a buffer reload.
	set nobackup " Do not keep a backup copy of a file.
	set nowritebackup " Do not write temporary backup files.
	set noswapfile " Do not create swap files.
" }}
" Helper functions {{
	" Set the tab width in the current buffer (see also http://vim.wikia.com/wiki/Indenting_source_code).
	func! SetTabWidth(w)
		let twd=(a:w>0)?(a:w):1 " Disallow non-positive width
		" For the following assignment, see :help let-&.
		" See also http://stackoverflow.com/questions/12170606/how-to-set-numeric-variables-in-vim-functions.
		let &l:tabstop=twd
		let &l:shiftwidth=twd
		let &l:softtabstop=twd
	endfunc

	" Set the tab width globally.
	func! SetGlobalTabWidth(w)
		let twd=(a:w>0)?(a:w):1
		let &tabstop=twd
		let &shiftwidth=twd
		let &softtabstop=twd
	endfunc

	" Alter the tab width in the current buffer.
	" To decrease the tab width, pass a negative value.
	func! IncreaseTabWidth(incr)
		call SetTabWidth(&tabstop + a:incr)
	endfunc

	" Delete trailing white space.
	func! RemoveTrailingSpace()
		" Save window state
		let l:winview = winsaveview()
		%s/\s\+$//ge
		" Restore window state
		call winrestview(l:winview)
		echomsg 'Trailing space removed!'
	endfunc

	func! ToggleBackgroundColor()
		" Seoul256 with custom background colors requires
		" special treatment to switch between dark and light background:
		if exists('g:colors_name')
			if g:colors_name ==# 'seoul256'
				colorscheme seoul256-light
				return
			elseif g:colors_name ==# 'seoul256-light'
				colorscheme seoul256
				return
			endif
		endif
		let &background = (&background == 'dark') ? 'light' : 'dark'
	endfunc

	" Toggle soft-wrapped text in the current buffer.
	func! ToggleWrap()
		if &l:wrap
			setl nowrap
			if mapcheck("j") != ""
				unmap <buffer> j
				unmap <buffer> k
			endif
		else
			setl wrap
			map <buffer> j gj
			map <buffer> k gk
		endif
	endfunc

	" See http://stackoverflow.com/questions/4064651/what-is-the-best-way-to-do-smooth-scrolling-in-vim
	func! SmoothScroll(up)
		let scrollaction = a:up ? "\<c-y>" : "\<c-e>"
		exe "normal " . scrollaction
		redraw
		for counter in range(3, &scroll, 2)
			sleep 10m
			exe "normal " . scrollaction
			redraw
		endfor
	endfunc

	" Find all occurrences of a pattern in a file.
	func! FindAll(pattern)
		exec "noautocmd lvimgrep " . a:pattern . " % | lopen"
	endfunc

	" Find all occurrences of a pattern in all open files.
	func! MultiFind(pattern)
		exec "noautocmd bufdo vimgrepadd " . a:pattern . " % | copen"
	endfunc

	func! Cheatsheet()
		botright vert 40sview ${HOME}/.vim/cheatsheet.txt
		setlocal bufhidden=wipe nobuflisted noswapfile nowrap
		nnoremap <silent> <buffer> <Tab> <C-w><C-w>
		nnoremap <silent> <buffer> q <C-w>c
	endfunc

	" Run an external command and display its output in a new buffer.
	" cmdline: the command to be executed;
	" pos: a letter specifying the position of the output window.
	" See http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
	" See also https://groups.google.com/forum/#!topic/vim_use/4ZejMpt7TeU
	func! RunShellCommand(cmdline, pos) abort
		let winpos_map = {
			\ "T": "to new",  "t": "abo new", "B": "bo new",  "b": "bel new",
			\ "L": "to vnew", "l": "abo vnew", "R": "bo vnew", "r": "bel vnew"
			\ }
		let cmd = ""
		for part in split(a:cmdline, ' ')
			if part =~ '\v^[%#<]'
				let expanded_part = expand(part)
				let cmd .= ' ' . (expanded_part == "" ? part : shellescape(expanded_part))
			else
				let cmd .= ' ' . part
			endif
		endfor
		exec get(winpos_map, a:pos, "bo new")
		setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
		execute '%!'. cmd
		setlocal nomodifiable
		nnoremap <silent> <buffer> <Tab> <C-w><C-w>
		nnoremap <silent> <buffer> q <C-w>c
		" Uncomment the following line for debugging
		" echomsg cmd
		1
	endfunc

	" Execute a non-interactive Git command in the directory containing
	" the file of the current buffer, and send the output to a new buffer.
	" args: a string of arguments for the commmand
	" pos: a letter specifying the position of the new buffer (see RunShellCommand()).
	func! Git(args, pos)
		call RunShellCommand("git -C %:p:h " . a:args, a:pos)
	endfunc

	" Show a vertical diff (use <C-w> K to arrange horizontally)
	" between the current buffer and its last committed version.
	func! GitDiff()
		let ft = getbufvar("%", '&ft') " Get the file type
		call Git("show HEAD:./" . shellescape(expand("%:t")), 'r')
		let &l:filetype = ft
		file HEAD
		au BufWinLeave <buffer> diffoff!
		diffthis
		wincmd p
		diffthis
	endfunc

	" Show a three-way diff. Useful for fixing merge conflicts.
	" This assumes that the current file is the working copy, of course.
	func! Git3WayDiff()
		let filename = shellescape(expand("%:t"))
		let ft = getbufvar("%", "&ft") " Get the file type
		" Show the version from the current branch on the left
		call Git("show :2:./" . filename, "l")
		let &l:filetype = ft
		file OURS
		au BufWinLeave <buffer> diffoff!
		diffthis
		wincmd p
		" Show version from the other branch on the right
		call Git("show :3:./" . filename, "r")
		let &l:filetype = ft
		file OTHER
		au BufWinLeave <buffer> diffoff!
		diffthis
		wincmd p
		diffthis
	endfunc

	" An outliner in less than 20 lines of code! The format is compatible with
	" VimOutliner (just in case we decide to use it): lines starting with : are
	" used for notes (indent one level wrt to the owning node). Promote,
	" demote, move, (un)fold and reformat with standard commands (plus mappings
	" defined below). Do not leave blank lines between nodes.
	func! OutlinerFoldingRule(n)
		return getline(a:n) =~ '^\s*:' ? 20 : indent(a:n) < indent(a:n+1) ? ('>'.(1+indent(a:n)/&l:tabstop)) : (indent(a:n)/&l:tabstop)
	endfunc

	func! EnableOutliner()
		setlocal autoindent
		setlocal formatoptions=tcqrnjo
		setlocal comments=fb:*,fb:-,b::
		setlocal textwidth=80
		setlocal foldmethod=expr
		setlocal foldexpr=OutlinerFoldingRule(v:lnum)
		setlocal foldtext=getline(v:foldstart)
		setlocal foldlevel=2
		" Full display with collapsed notes:
		nnoremap <buffer> <silent> <Leader>n :set foldlevel=19<CR>
		call SetTabWidth(4)
	endfunc
" }}
" Commands (plugins excluded) {{
	" Execute external command and show output in a new buffer
	command! -complete=shellcmd -nargs=+ Shell      call RunShellCommand(<q-args>, "B")
	command! -complete=shellcmd -nargs=+ ShellRight call RunShellCommand(<q-args>, "R")
	command! -complete=shellcmd -nargs=+ ShellTop   call RunShellCommand(<q-args>, "T")

	" Execute an arbitrary (non-interactive) Git command and show the output in a new buffer.
	command! -complete=shellcmd -nargs=+ Git call Git(<q-args>, "B")

	" Three-way diff
	command! -nargs=0 Conflicts call Git3WayDiff()

	" Save file with sudo
	command W :w !sudo tee % >/dev/null

	" Find all in current buffer
	command! -nargs=1 FindAll call FindAll(<q-args>)

	" Find all in all open buffers
	command! -nargs=1 MultiFind call MultiFind(<q-args>)
" }}
" Editing {{
	set backspace=indent,eol,start " Intuitive backspacing in insert mode.
	set whichwrap+=<,>,[,],h,l " More intuitive arrow movements.
	set scrolloff=999 " Keep the edited line vertically centered.
	" set clipboard=unnamed " Use system clipboard by default.
	" Smooth scrolling that works both in terminal and in MacVim
	nnoremap <silent> <C-U> :call SmoothScroll(1)<Enter>
	nnoremap <silent> <C-D> :call SmoothScroll(0)<Enter>
	" Scroll the viewport faster.
	nnoremap <C-e> <C-e><C-e>
	nnoremap <C-y> <C-y><C-y>
	set showmatch " Show matching brackets/parenthesis
	set matchtime=2 " show matching bracket for 0.2 seconds
	set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
	set splitright " Puts new vsplit windows to the right of the current
	set splitbelow " Puts new split windows to the bottom of the current
	set formatoptions-=o " Do not automatically insert comment when opening a line
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
	call SetGlobalTabWidth(2)
" }}
" Find, replace, and auto-complete {{
	" set gdefault " Apply substitutions globally by default
	" set hlsearch " Highlight search terms.
	set incsearch " Search as you type.
	set ignorecase " Case-insensitive search by default.
	set smartcase " Use case-sensitive search if there is a capital letter in the search expression.
	set infercase " Smart keyword completion
	set wildmenu " Show possible matches when autocompleting.
	set wildignorecase " Ignore case when completing file names and directories.
	" set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all.
" }}
" Key mappings (plugins excluded) {{
	" A handy cheat sheet ;)
	nnoremap <silent> <Leader>? :call Cheatsheet()<CR>
	" Enable outline mode for the current buffer
	nnoremap <silent> <Leader>O :call EnableOutliner()<CR>
	" Toggle between hard tabs and soft tabs in the current buffer
	nnoremap <silent> cot :setlocal invexpandtab<CR>
	" Increase tab width by one in the current buffer
	nnoremap <silent> <Leader>+ :call IncreaseTabWidth(+1)<CR>
	" Decrease tab width by one in the current buffer
	nnoremap <silent> <Leader>- :call IncreaseTabWidth(-1)<CR>
	" Add blank line below or above the current line, but stay in normal mode
	" (see http://vim.wikia.com/wiki/Quickly_adding_and_deleting_empty_lines)
	" (see also http://stackoverflow.com/questions/16359878/vim-how-to-map-shift-enter)
	nnoremap <silent> ]<Space> :set paste<CR>m`o<Esc>``:set nopaste<CR>
	nnoremap <silent> [<Space> :set paste<CR>m`O<Esc>``:set nopaste<CR>
	" Swap lines. See http://vim.wikia.com/wiki/VimTip646 for an explanation.
	nnoremap <silent> ]e :m .+1<CR>
	nnoremap <silent> [e :m .-2<CR>
	vnoremap <silent> ]e :m '>+1<CR>gv
	vnoremap <silent> [e :m '<-2<CR>gv
	" Toggle invisibles in the current buffer
	nnoremap <silent> coi :setlocal nolist!<CR>
	" Toggle spelling in the current buffer
	nnoremap <silent> cos :setlocal spell!<CR>
	" Toggle between hard-wrap and soft-wrap
	nnoremap <silent> cow :call ToggleWrap()<CR>
	" Remove trailing space globally
	nnoremap <silent> <Leader>S :call RemoveTrailingSpace()<CR>
	" Capitalize words in selected text (see h gU)
	vnoremap <silent> <Leader>U :s/\v<(.)(\w*)/\u\1\L\2/g<CR>
	" Toggle search highlighting
	nnoremap <silent> coh :set invhlsearch<CR>
	" Go to previous/next buffer
	nnoremap <silent> [b :bp<CR>
	nnoremap <silent> ]b :bn<CR>
	" Move between windows
	nnoremap <silent> <C-h> <C-w>h
	nnoremap <silent> <C-j> <C-w>j
	nnoremap <silent> <C-k> <C-w>k
	nnoremap <silent> <C-l> <C-w>l
	" Go to tab 1/2/3 etc
	nnoremap <Leader>1 1gt
	nnoremap <Leader>2 2gt
	nnoremap <Leader>3 3gt
	nnoremap <Leader>4 4gt
	nnoremap <Leader>5 5gt
	nnoremap <Leader>6 6gt
	nnoremap <Leader>7 7gt
	nnoremap <Leader>8 8gt
	nnoremap <Leader>9 9gt
	nnoremap <Leader>0 10gt
	" Toggle absolute line numbers
	nnoremap <silent> con :set invnumber<CR>:set nornu<CR>
	" Toggle relative line numbers
	nnoremap <silent> cor :set invnumber<CR>:set rnu<CR>
	" Toggle background color
	noremap <silent> cob :call ToggleBackgroundColor()<CR>
	" Compare buffer with HEAD
	nnoremap <silent> <Leader>gd :call GitDiff()<CR>
	" Git status
	nnoremap <silent> <Leader>gs :Git status<CR>:setlocal ft=gitcommit<CR>
	" Git commit
	nnoremap <silent> <Leader>gc :!git -C '%:p:h' commit<CR>
	" Show the revision history for the current file
	nnoremap <silent> <Leader>gl :Git log --oneline -- %<CR>
	" Add files/patches to the index
	nnoremap <silent> <Leader>ga :!git -C '%:p:h' add -p '%:p'<CR>
	" Git push
	nnoremap <silent> <Leader>gp :!git -C '%:p:h' push<CR>
	" Find next/prev merge conflict markers
	nnoremap <silent> ]n /\v^[<\|=>]{7}<CR>
	nnoremap <silent> [n ?\v^[<\|=>]{7}<CR>
	" Use bindings in command mode similar to those used by the shell (see also :h cmdline-editing)
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	cnoremap <C-p> <Up>
	cnoremap <C-n> <Down>
	" cnoremap <C-b> <Left>
	" cnoremap <C-f> <Right>
	" Allow using alt-arrows to jump over words in OS X, as in Terminal.app
	cnoremap <Esc>b <S-Left>
	cnoremap <Esc>f <S-Right>
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
	set fillchars=vert:\  " Get rid of vertical split separator (http://stackoverflow.com/questions/9001337/vim-split-bar-styling)
	set fillchars+=fold:\·
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
	" To add support for a new theme, define a function called
	" CustomizeTheme_<theme_name>. That function will be automatically called
	" after the color scheme is activated. The function should at least
	" define the hightlight groups for the status line, but it can also
	" be used to override the theme's settings and highlight groups.

	" Set up highlight groups for the current theme and background.
	func! CustomizeTheme()
		" Set default values for the highlight groups of the status line
		hi link NormalMode  StatusLine
		hi link InsertMode  StatusLine
		hi link VisualMode  StatusLine
		hi link ReplaceMode StatusLine
		hi link CommandMode StatusLine
		hi link Warnings    StatusLine
		if exists('g:colors_name')
			let fn = 'CustomizeTheme_' . substitute(tolower(g:colors_name), '[-]', '_', 'g')
			if exists('*' . fn)
				call eval(fn . '()')
			endif
		endif
	endfunc

	autocmd ColorScheme * call CustomizeTheme()

	" Solarized {{
		let g:solarized_bold = 1
		let g:solarized_underline = 0

		func! CustomizeTheme_solarized()
			if &background ==# 'dark'
				hi VertSplit   ctermbg=0  ctermfg=0  guibg=#073642 guifg=#073642 term=reverse cterm=reverse gui=reverse
				hi MatchParen  ctermbg=0  ctermfg=14 guibg=#073642 guifg=#93a1a1 term=bold    cterm=bold    gui=bold
			else
				hi VertSplit   ctermbg=7  ctermfg=7  guibg=#eee8d5 guifg=#eee8d5 term=reverse cterm=reverse gui=reverse
				hi MatchParen  ctermbg=7  ctermfg=0  guibg=#eee8d5 guifg=#073642 term=bold    cterm=bold    gui=bold
				hi TabLineSel  ctermbg=10 ctermfg=15 guibg=#586e75 guifg=#fdf6e3 term=reverse cterm=reverse gui=reverse
				hi TabLine     ctermbg=7  ctermfg=14 guibg=#eee8d5 guifg=#93a1a1 term=reverse cterm=reverse gui=reverse
				hi TabLineFill ctermbg=7  ctermfg=14 guibg=#eee8d5 guifg=#93a1a1 term=reverse cterm=reverse gui=reverse
			endif
			hi clear Title
			hi clear Folded
			hi clear SignColumn

			" Status line
			if &background ==# 'dark'
				hi StatusLine   ctermbg=7   ctermfg=10  guibg=#eee8d5 guifg=#586e75 term=reverse cterm=reverse gui=reverse
				hi StatusLineNC ctermbg=10  ctermfg=0   guibg=#586e75 guifg=#073642 term=reverse cterm=reverse gui=reverse
				hi NormalMode   ctermbg=14  ctermfg=15  guibg=#93a1a1 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			else
				hi StatusLine   ctermbg=7   ctermfg=14  guibg=#eee8d5 guifg=#93a1a1 term=reverse cterm=reverse gui=reverse
				hi StatusLineNC ctermbg=14  ctermfg=7   guibg=#93a1a1 guifg=#eee8d5 term=reverse cterm=reverse gui=reverse
				hi NormalMode   ctermbg=10  ctermfg=15  guibg=#586e75 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			endif
			hi InsertMode      ctermbg=6   ctermfg=15  guibg=#2aa198 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			hi ReplaceMode     ctermbg=9   ctermfg=15  guibg=#cb4b16 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			hi VisualMode      ctermbg=5   ctermfg=15  guibg=#d33682 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			hi CommandMode     ctermbg=5   ctermfg=15  guibg=#d33682 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			hi Warnings        ctermbg=1   ctermfg=15  guibg=#dc322f guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
		endfunc
	" }}
	" Seoul256 {{
		let g:seoul256_background = 236
		let g:seoul256_light_background = 255

		func! CustomizeTheme_seoul256()
			hi VertSplit    ctermbg=239 ctermfg=239 guibg=#616161 guifg=#616161 term=reverse cterm=reverse gui=reverse
			hi TabLineSel   ctermbg=236 ctermfg=187 guibg=#3f3f3f guifg=#dfdebd term=NONE    cterm=NONE    gui=NONE
			hi TabLine      ctermbg=239 ctermfg=249 guibg=#616161 guifg=#bfbfbf term=NONE    cterm=NONE    gui=NONE
			hi TabLineFill  ctermbg=239 ctermfg=249 guibg=#616161 guifg=#bfbfbf term=NONE    cterm=NONE    gui=NONE
			" Status line
			hi StatusLineNC ctermbg=187 ctermfg=239 guibg=#dfdebd guifg=#616161 term=reverse cterm=reverse gui=reverse
			hi StatusLine   ctermbg=187 ctermfg=95  guibg=#dfdebd guifg=#9a7372 term=reverse cterm=reverse gui=reverse
			hi NormalMode   ctermbg=239 ctermfg=187 guibg=#616161 guifg=#dfdebd term=NONE    cterm=NONE    gui=NONE
			hi InsertMode   ctermbg=65  ctermfg=187 guibg=#719872 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			hi ReplaceMode  ctermbg=220 ctermfg=238 guibg=#ffdd00 guifg=#565656 term=NONE    cterm=NONE    gui=NONE
			hi VisualMode   ctermbg=23  ctermfg=252 guibg=#007173 guifg=#d9d9d9 term=NONE    cterm=NONE    gui=NONE
			hi CommandMode  ctermbg=52  ctermfg=187 guibg=#730b00 guifg=#dfdebd term=NONE    cterm=NONE    gui=NONE
			hi Warnings     ctermbg=52  ctermfg=252 guibg=#730b00 guifg=#d9d9d9 term=NONE    cterm=NONE    gui=NONE
		endfunc

		func! CustomizeTheme_seoul256_light()
			hi TabLineSel   ctermbg=255 ctermfg=238 guibg=#f0f1f1 guifg=#565656 term=NONE    cterm=NONE    gui=NONE
			hi TabLine      ctermbg=252 ctermfg=243 guibg=#d9d9d9 guifg=#d1d0d1 term=NONE    cterm=NONE    gui=NONE
			hi TabLineFill  ctermbg=252 ctermfg=243 guibg=#d9d9d9 guifg=#d1d0d1 term=NONE    cterm=NONE    gui=NONE
			" Status line
			hi StatusLine   ctermbg=187 ctermfg=95  guibg=#dfdebd guifg=#9a7372 term=reverse cterm=reverse gui=reverse
			hi StatusLineNC ctermbg=238 ctermfg=251 guibg=#565656 guifg=#d1d0d1 term=reverse cterm=reverse gui=reverse
			hi NormalMode   ctermbg=239 ctermfg=187 guibg=#616161 guifg=#dfdebd term=NONE    cterm=NONE    gui=NONE
			hi InsertMode   ctermbg=65  ctermfg=187 guibg=#719872 guifg=#fdf6e3 term=NONE    cterm=NONE    gui=NONE
			hi ReplaceMode  ctermbg=220 ctermfg=238 guibg=#ffdd00 guifg=#565656 term=NONE    cterm=NONE    gui=NONE
			hi VisualMode   ctermbg=23  ctermfg=252 guibg=#007173 guifg=#d9d9d9 term=NONE    cterm=NONE    gui=NONE
			hi CommandMode  ctermbg=52  ctermfg=187 guibg=#730b00 guifg=#dfdebd term=NONE    cterm=NONE    gui=NONE
			hi Warnings     ctermbg=52  ctermfg=252 guibg=#730b00 guifg=#d9d9d9 term=NONE    cterm=NONE    gui=NONE
		endfunc
	" }}
	" PaperColor {{
		func! CustomizeTheme_papercolor()
			set fillchars=vert:\|,fold:\·
			hi clear Title
			hi StatusLine term=NONE cterm=NONE gui=NONE
			hi TabLine      ctermbg=255 ctermfg=24  guibg=#f5f5f5 guifg=#005f87 term=reverse cterm=reverse gui=reverse
			hi TabLineSel   ctermbg=238 ctermfg=255 guibg=#4d4d4c guifg=#f5f5f5 term=reverse cterm=reverse gui=reverse
			" Status line
			hi NormalMode   ctermbg=254 ctermfg=240 guibg=#e4e4e4 guifg=#585858 term=NONE    cterm=NONE    gui=NONE
			hi InsertMode   ctermbg=31  ctermfg=255 guibg=#3e999f guifg=#f5f5f5 term=NONE    cterm=NONE    gui=NONE
			hi ReplaceMode  ctermbg=166 ctermfg=255 guibg=#d75f00 guifg=#f5f5f5 term=NONE    cterm=NONE    gui=NONE
			hi VisualMode   ctermbg=25  ctermfg=255 guibg=#4271ae guifg=#f5f5f5 term=NONE    cterm=NONE    gui=NONE
			hi CommandMode  ctermbg=238 ctermfg=255 guibg=#4d4d4c guifg=#f5f5f5 term=NONE    cterm=NONE    gui=NONE
			hi Warnings     ctermbg=161 ctermfg=255 guibg=#d7005f guifg=#f5f5f5 term=NONE    cterm=NONE    gui=NONE
		endfunc
	" }}

	" Default theme
	if filereadable($HOME . '/.vim/default-theme.vim')
		exec 'source' $HOME . '/.vim/default-theme.vim'
	else
		colorscheme solarized
	endif
" }}
" Status line {{
	" See :h mode() (some of these are never used in the status line)
	let g:mode_map = {
				\ 'n':  ['NORMAL',  'NormalMode' ], 'no':     ['PENDING', 'NormalMode' ], 'v': ['VISUAL',  'VisualMode' ],
				\ 'V':  ['V-LINE',  'VisualMode' ], "\<C-v>": ['V-BLOCK', 'VisualMode' ], 's': ['SELECT',  'VisualMode' ],
				\ 'S':  ['S-LINE',  'VisualMode' ], "\<C-s>": ['S-BLOCK', 'VisualMode' ], 'i': ['INSERT',  'InsertMode' ],
				\ 'R':  ['REPLACE', 'ReplaceMode'], 'Rv':     ['REPLACE', 'ReplaceMode'], 'c': ['COMMAND', 'CommandMode'],
				\ 'cv': ['COMMAND', 'CommandMode'], 'ce':     ['COMMAND', 'CommandMode'], 'r': ['PROMPT',  'CommandMode'],
				\ 'rm': ['-MORE-',  'CommandMode'], 'r?':     ['CONFIRM', 'CommandMode'], '!': ['SHELL',   'CommandMode'] }

	" Update trailing space and mixed indent warnings for the current buffer.
	" See http://got-ravings.blogspot.it/2008/10/vim-pr0n-statusline-whitespace-flags.html
	func! UpdateWarnings()
		let save_cursor = getcurpos()
		call cursor(1,1) " Start search from the beginning of the file
		let trail = search('\s$', 'nw')
		let spaces = search('\v^\s* ', 'nw')
		let tabs = search('\v^\s*\t', 'nw')
		if trail != 0
			let b:stl_warnings = '  trailing space ('.trail.') '
			if spaces != 0 && tabs != 0
				let b:stl_warnings .= 'mixed indent ('.spaces.'/'.tabs.') '
			endif
		elseif spaces != 0 && tabs != 0
			let b:stl_warnings = '  mixed indent ('.spaces.'/'.tabs.') '
		else
			unlet! b:stl_warnings
		endif
		call setpos('.', save_cursor) " Restore cursor position
	endfunc

	func! SetupStl(nr)
		exec 'hi! link CurrMode ' . ((winnr() == a:nr) ? get(g:mode_map, mode(1), ['','Warnings'])[1] : 'StatusLineNC')
		return get(extend(w:, {"bufnr": winbufnr(winnr()), "active": (winnr() == a:nr),
					\ "ft": getbufvar(winbufnr(winnr()), "&ft"), "winwd": winwidth(winnr())}), '', '')
	endfunc

	" Build the status line the way I want - no fat light plugins!
	func! BuildStatusLine(nr)
		return '%{SetupStl('.a:nr.')}%#CurrMode#
					\ %{w:["active"] ? get(g:mode_map,mode(1), ["??????"])[0] . (&paste ? " PASTE" : "") : " "}
					\ %* %<%F
					\ %{getbufvar(w:["bufnr"], "&modified") ? "◇" : " "}
					\ %{getbufvar(w:["bufnr"], "&modifiable") ? (getbufvar(w:["bufnr"], "&readonly") ? "✗" : "") : "⚔"}
					\ %=
					\ %{w:["ft"]}
					\ %{w:["winwd"] < 80 || w:["ft"] =~ "help" ? "" : " "
					\ . (getbufvar(w:["bufnr"], "&fenc") . (getbufvar(w:["bufnr"], "&bomb") ? ",BOM" : "") . " "
					\ . (getbufvar(w:["bufnr"], "&ff") ==# "unix" ? "␊ (Unix)" :
					\   (getbufvar(w:["bufnr"], "&ff") ==# "mac"  ? "␍ (Classic Mac)" :
					\   (getbufvar(w:["bufnr"], "&ff") ==# "dos"  ? "␍␊ (Windows)" : "? (Unknown)"))) . " "
					\ . (getbufvar(w:["bufnr"], "&expandtab") ==# "expandtab" ? "⇥ " : "˽ ") . getbufvar(w:["bufnr"], "&tabstop"))}
					\ %#CurrMode#%{w:["winwd"] < 60 ? "" : printf(" %d:%-2d %2d%% ", line("."), virtcol("."), 100 * line(".") / line("$"))}%*
					\%#Warnings#%{(!w:["active"] || !exists("b:stl_warnings") || w:["ft"] =~ "help") ? "" : b:stl_warnings}%*'
	endfunc

	func! EnableStatusLine()
		let g:default_stl = &statusline
		augroup status
			autocmd!
			autocmd BufReadPost,BufWritePost * call UpdateWarnings()
		augroup END
		set statusline=%!BuildStatusLine(winnr()) " In this context, winnr() is always the window number of the *active* window
	endfunc!

	func! DisableStatusLine()
		augroup status
			autocmd!
		augroup END
		augroup! status
		let &statusline = g:default_stl
	endfunc!

	call EnableStatusLine()
" }}
" Tabline {{
	" See :h tabline
	func! BuildTabLabel(nr)
		return " " . a:nr . (empty(filter(tabpagebuflist(a:nr), 'getbufvar(v:val, "&modified")')) ? " " : " ◇ ")
					\ . (get(extend(t:, {"tablabel": fnamemodify(bufname(tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1]), ":t")}), "tablabel") == "" ? "[No Name]" : get(t:, "tablabel")) . "  "
	endfunc

	func! BuildTabLine()
		return join(map(range(1, tabpagenr('$')),
					\ '((v:val == tabpagenr()) ? "%#TabLineSel#" : "%#TabLine#") . "%".v:val."T %{BuildTabLabel(".v:val.")}"'), '')
					\ . "%#TabLineFill#%T"
					\ . (tabpagenr('$') > 1 ? "%=%#TabLine#%999X✕ " : "")
	endfunc

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
		func! CtrlP_Main(...)
			if a:1 ==# 'prt'
				let color = '%#InsertMode#'
				let rhs = color . (a:3 ? ' regex ' : ' match ') . a:2 . ' %*'
			else
				let color = '%#VisualMode#'
				let rhs = color . ' select %*'
			endif
			let item = color . ' ' . a:5 . ' %*'
			let dir = ' ' . getcwd()
			return item . dir . '%=' . rhs
		endfunc

		" Argument: len
		"           a:1
		func! CtrlP_Progress(...)
			let len = '%#Warnings# ' . a:1 . ' %*'
			let dir = ' %=%<%#Warnings#' . getcwd() . ' %*'
			return len . dir
		endfunc
	" }}
	" Easy Align {{
		vmap <Enter> <Plug>(EasyAlign)
	" }}
	" EasyMotion {{
		let g:EasyMotion_do_mapping = 0
		let g:EasyMotion_smartcase = 1
		map  <Leader>/ <Plug>(easymotion-sn)
		omap <Leader>/ <Plug>(easymotion-tn)
		nmap <Leader>s <Plug>(easymotion-s)
		omap <Leader>s <Plug>(easymotion-s)
	" }}
	" Goyo {{
		" Toggle distraction-free mode
		nnoremap <silent> <F7> :Goyo<CR>
		func! s:goyo_enter()
			call DisableStatusLine()
			if has('gui_macvim')
				"set fullscreen
				set guifont=Monaco:h14
				set linespace=7
				set guioptions-=r " hide right scrollbar
			endif
			set wrap
			set noshowcmd
			Limelight
		endfunc

		func! s:goyo_leave()
			if has('gui_macvim')
				"set nofullscreen
				set guifont=Monaco:h14
				set linespace=0
				set guioptions+=r
			endif
			set nowrap
			set showcmd
			Limelight!
			call EnableStatusLine()
		endfunc

		autocmd! User GoyoEnter
		autocmd! User GoyoLeave
		autocmd! User GoyoEnter nested call <SID>goyo_enter()
		autocmd! User GoyoLeave nested call <SID>goyo_leave()
	" }}
	" LaTeX-Box {{
		if has('gui_macvim')
			let g:LatexBox_latexmk_async = 1
		else
			let g:LatexBox_latexmk_async = 0
		endif
		let g:LatexBox_latexmk_preview_continuously = 0
		let g:LatexBox_quickfix = 2
		let g:LatexBox_latexmk_options = "-pdflatex='pdflatex -synctex=1 \%O \%S'"
		let g:LatexBox_viewer = 'open -a Skim.app'
		au FileType tex nnoremap <silent> <Leader>ls :silent
					\ !${HOME}/Applications/Skim.app/Contents/SharedSupport/displayline
					\ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>"
					\ "%:p" <CR>
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
		func! ToggleShowMarks()
			if exists('b:showmarks')
				NoShowMarks
			else
				DoShowMarks
			endif
		endfunc

		" Toggle marks
		nnoremap <silent> <Leader>m :call ToggleShowMarks()<CR>
		nnoremap ` :ShowMarksOnce<CR>`
	" }}
	" Tagbar {{
		" Toggle tag bar
		nnoremap <silent> <F9> :TagbarToggle<CR>
		let g:tagbar_autofocus = 1
		let g:tagbar_iconchars = ['▸', '▾']
	" }}
	" Undotree {{
		let g:undotree_SplitWidth = 40
		let g:undotree_SetFocusWhenToggle = 1
		let g:undotree_TreeNodeShape = '◦'
		" Toggle undo tree
		nnoremap <silent> <F8> :UndotreeToggle<CR>
	" }}
" }}

