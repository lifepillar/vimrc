" Modeline and Notes {{
" vim: set sw=3 ts=3 sts=0 noet tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker foldtext=substitute(getline(v\:foldstart),'\\"\\s\\\|\{\{','','g') nospell:
"
" Remember to check "Set locale environment variables on startup" in OS X Terminal.app's preferences.
" }}

" Environment {{
	set nocompatible " Must be first line.
	" See http://stackoverflow.com/questions/18321538/vim-error-e474-invalid-argument-listchars-tab-trail
	scriptencoding utf-8
	set encoding=utf-8
	set termencoding=utf-8
	set nobomb
	set fileformats=unix,mac,dos
	syntax enable
	filetype on " Enable file type detection.
	" File-type specific configuration {{
		autocmd BufNewFile,BufReadPost *.md,*.mmd set filetype=markdown; spell spelllang=en
		" Instead of reverting the cursor to the last position in the buffer, we
		" set it to the first line when editing a git commit message:
		au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
	" }}
	filetype plugin on " Enable loading the plugin files for specific file types.
	filetype indent on " Load indent files for specific file types.
	runtime bundle/pathogen/autoload/pathogen.vim " Load Pathogen.
	execute pathogen#infect()
	set sessionoptions-=options " See FAQ at https://github.com/tpope/vim-pathogen.
	set autoread " Re-read file if it is changed by an external program.
	set hidden " Allow buffer switching without saving.
	set history=1000 " Keep a longer history.
	" Consolidate temporary files in a central spot:
	set backupdir=~/.vim/tmp
	set directory=~/.vim/tmp
	set viminfo+=n~/.vim/viminfo
	if has('persistent_undo')
		set undofile
		set undodir=~/.vim/tmp
		set undolevels=1000         " Maximum number of changes that can be undone.
		set undoreload=10000        " Maximum number lines to save for undo on a buffer reload.
	endif
	set nowritebackup " Don't write backup files.
" }}

" Helper functions {{
	" Set tab width in the current buffer (see also http://vim.wikia.com/wiki/Indenting_source_code).
	func! SetTabWidth(w)
		let twd=(a:w>0)?(a:w):1 " Disallow non-positive width
		" For the following assignment, see :help let-&.
		" See also http://stackoverflow.com/questions/12170606/how-to-set-numeric-variables-in-vim-functions.
		let &l:tabstop=twd
		let &l:shiftwidth=twd
		let &l:softtabstop=twd
	endfunc

	" Set tab width globally.
	func! SetGlobalTabWidth(w)
		let twd=(a:w>0)?(a:w):1
		let &tabstop=twd
		let &shiftwidth=twd
		let &softtabstop=twd
	endfunc

	" Alter tab width in the current buffer.
	" To decrease the tab width, pass a negative value.
	func! IncreaseTabWidth(incr)
		call SetTabWidth(&tabstop + a:incr)
	endfunc

	" Delete trailing white space
	func! RemoveTrailingSpace()
		" Mark current cursor position (see :h restore-position):
		exe "normal msHmt"
		%s/\s\+$//ge
		" Restore cursor position
		exe "normal 'tzt`s"
	endfunc

	func! ToggleBackgroundColor()
		if &background == 'dark'
			let &background = 'light'
		else
			let &background = 'dark'
		endif
	endfunc
" }}

" Editing {{
	set backspace=indent,eol,start " Intuitive backspacing in insert mode.
	set whichwrap+=<,>,[,],h,l " More intuitive arrow movements.
	set scrolloff=999 " Keep the edited line vertically centered.
	" set clipboard=unnamed " Use system clipboard by default.
	" See :h scroll-smooth
	noremap <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
	noremap <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>
	" Scroll the viewport faster.
	nnoremap <C-e> <C-e><C-e>
	nnoremap <C-y> <C-y><C-y>
	" Easier horizontal scrolling:
	nnoremap zl 10zl
	nnoremap zh 10zh
	set showmatch " Show matching brackets/parenthesis
	set matchtime=2 " show matching bracket for 0.2 seconds
	set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
	set splitright " Puts new vsplit windows to the right of the current
	set splitbelow " Puts new split windows to the bottom of the current
	" Load matchit.vim, but only if the user hasn't installed a newer version.
	if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
		runtime! macros/matchit.vim " Enable % to go to matching keyword/tag.
	endif
	" Shift left/right repeatedly
	vnoremap > >gv
	vnoremap < <gv
	" Use soft tabs by default:
	set expandtab
	call SetGlobalTabWidth(2)
" }}

" Find, replace, and auto-complete {{
	" set gdefault " Apply substitutions globally by default
	" set hlsearch " Highlight search terms.
	set incsearch " Search as you type.
	set ignorecase " Case-insensitive search by default.
	set smartcase " Use case-sensitive search if there is a capital letter in the search expression.
	set wildmenu " Show possible matches when autocompleting.
	if exists("&wildignorecase") " Vim >=7.3 build 107.
		set wildignorecase " Ignore case when completing file names and directories.
	endif
	" set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all.
" }}

" Key mappings (plugins excluded) {{
	" Swap ; and :  Convenient.
	nnoremap ; :
	nnoremap : ;
	vnoremap ; :
	vnoremap : ;
	" Use ctrl-j as Esc in insert/visual mode (convenient).
	inoremap <C-j> <Esc>
	vnoremap <C-j> <Esc>
	let mapleader = ","
	" A handy cheat sheet ;)
	nnoremap <silent> <Leader>cs :vert 40sview ${HOME}/.vim/cheatsheet.txt<CR>
	" Close current buffer with ,w:
	nnoremap <silent> <Leader>w :bd<CR>
	" Toggle between hard tabs and soft tabs in the current buffer:
	nnoremap <silent> <Leader>t :setlocal invexpandtab<CR>
	" Increase tab width by one in the current buffer:
	nnoremap <silent> <Leader>] :call IncreaseTabWidth(+1)<CR>
	" Decrease tab width by one in the current buffer:
	nnoremap <silent> <Leader>[ :call IncreaseTabWidth(-1)<CR>
	" Toggle invisibles in the current buffer with ,i:
	nnoremap <silent> <Leader>i :setlocal nolist!<CR>
	" Toggle spelling in the current buffer with ,s:
	nnoremap <silent> <Leader>s :setlocal spell!<CR>
	" Remove trailing space globally with ,ts:
	nnoremap <Leader>ts :call RemoveTrailingSpace()<CR>
	" Select all with ,a:
	nnoremap <silent> <Leader>a ggVG<CR>
	" Capitalize words in selected text with ,U (see h gU):
	vnoremap <silent> <Leader>U :s/\v<(.)(\w*)/\u\1\L\2/g<CR>
	" Toggle search highlighting with ,h:
	nnoremap <silent> <Leader>h :set invhlsearch<CR>
	" Hard-wrap paragraphs at textwidth with ,r:
	nnoremap <silent> <leader>r gwap
	" Mappings to access buffers.
	" ,l       : list buffers
	" ,b ,f ,g : go back/forward/last-used
	" ,1 ,2 ,3 : go to buffer 1/2/3 etc:
	nnoremap <Leader>l :ls<CR>
	nnoremap <Leader>b :bp<CR>
	nnoremap <Leader>f :bn<CR>
	nnoremap <Leader>g :e#<CR>
	nnoremap <Leader>1 :1b<CR>
	nnoremap <Leader>2 :2b<CR>
	nnoremap <Leader>3 :3b<CR>
	nnoremap <Leader>4 :4b<CR>
	nnoremap <Leader>5 :5b<CR>
	nnoremap <Leader>6 :6b<CR>
	nnoremap <Leader>7 :7b<CR>
	nnoremap <Leader>8 :8b<CR>
	nnoremap <Leader>9 :9b<CR>
	nnoremap <Leader>0 :10b<CR>
	" Toggle absolute line numbers with ,n:
	nnoremap <silent> <Leader>n :set invnumber<CR>:set nornu<CR>
	" Toggle relative line numbers with ,m:
	nnoremap <silent> <Leader>m :set invnumber<CR>:set rnu<CR>
	" Toggle background color with F7:
	noremap <silent> <F7> :call ToggleBackgroundColor()<CR>
	" Find merge conflict markers with ,fc:
	nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
	" Use bindings in command mode similar to those used by the shell (see also :h cmdline-editing):
	cnoremap <C-a> <Home>
	cnoremap <C-e> <End>
	cnoremap <C-p> <Up>
	cnoremap <C-n> <Down>
	" cnoremap <C-b> <Left>
	" cnoremap <C-f> <Right>
	" Allow using alt-arrows to jump over words in OS X, as in Terminal.app:
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
	set listchars=tab:▸\ ,trail:·,eol:¬ " Symbols to use for invisible characters (see also http://stackoverflow.com/questions/20962204/vimrc-getting-e474-invalid-argument-listchars-tab-no-matter-what-i-do).
	" Theme
	set background=dark
	if filereadable(expand("~/.vim/bundle/solarized/colors/solarized.vim"))
	"	let g:solarized_termcolors=256
	"	let g:solarized_termtrans=0
	"	let g:solarized_degrade=0
		let g:solarized_bold=0
		let g:solarized_underline=0
	"	let g:solarized_italic=1
	"	let g:solarized_contrast="normal"   " high, low, normal
	"	let g:solarized_visibility="normal" " high, low, normal
		colorscheme solarized
	endif
	" GUI settings {{
		if has('gui_macvim')
			set guifont=Monaco:h14
			set guioptions+=a " Yank/paste to/from OS X clipboard
			set guicursor=n-v-c:ver20 " Use a thin vertical bar as the cursor
			set transparency=4
		endif
	" }}
" }}

" Status line {{
	" This was very helpful: http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/

	hi Active      ctermfg=7  ctermbg=10 guifg=#eee8d5 guibg=#586e75
	hi NormalMode  ctermfg=15 ctermbg=14 guifg=#fdf6e3 guibg=#93a1a1
	hi InsertMode  ctermfg=15 ctermbg=6  guifg=#fdf6e3 guibg=#2aa198
	hi ReplaceMode ctermfg=15 ctermbg=9  guifg=#fdf6e3 guibg=#cb4b16
	hi VisualMode  ctermfg=15 ctermbg=5  guifg=#fdf6e3 guibg=#d33682
	hi CommandMode ctermfg=15 ctermbg=5  guifg=#fdf6e3 guibg=#d33682
	hi Warnings    ctermfg=15 ctermbg=1  guifg=#fdf6e3 guibg=#dc322f
	hi Inactive    ctermfg=10 ctermbg=0  guifg=#586e75 guibg=#073642

	" Return the text and color to be used for the current mode
	func! GetModeInfo()
		let mode_map = {
					\ 'n':      ['NORMAL',  '%#NormalMode#' ],
					\ 'i':      ['INSERT',  '%#InsertMode#' ],
					\ 'R':      ['REPLACE', '%#ReplaceMode#'],
	  				\ 'v':      ['VISUAL',  '%#VisualMode#' ],
					\ 'V':      ['V-LINE',  '%#VisualMode#' ],
					\ "\<C-v>": ['V-BLOCK', '%#VisualMode#' ],
					\ 'c':      ['COMMAND', '%#CommandMode#'],
					\ 's':      ['SELECT',  '%#VisualMode#' ],
					\ 'S':      ['S-LINE',  '%#VisualMode#' ],
					\ "\<C-s>": ['S-BLOCK', '%#VisualMode#' ] }
		return get(mode_map, mode(), ['??????', 'Warnings'])
	endfunc

	" Build the status line the way I want - no fat light plugins!
	" bufnum: buffer number
	" active: 1=active, 0=inactive
	function! BuildStatusLine(bufnum, active)
		let encoding = getbufvar(a:bufnum, '&fenc')
		if encoding == ''
			let encoding = getbufvar(a:bufnum, '&enc')
		endif
		if getbufvar(a:bufnum, '&bomb')
			let encoding .= ',BOM'
		endif

		let ff = getbufvar(a:bufnum, '&ff')
		let fileformat = (ff ==? 'unix') ? '␊ (Unix)' : (ff ==? 'mac') ? '␍ (Classic Mac)' : (ff ==? 'dos') ? '␍␊ (Windows)' : '? (Unknown)'

		let stat = ''
		if a:active
			let modeinfo = GetModeInfo()
			let stat .= modeinfo[1] . modeinfo[0] . ' '  " Current mode
			if getbufvar(a:bufnum, '&paste')
				let stat .= 'PASTE '
			endif
			let stat .= '%#Active#'
		else
			let stat .= '%#Inactive#'
		endif

		let stat .= ' %<%F '  " Full path
		let stat .= getbufvar(a:bufnum, '&modified') ? '◇ ' : '  '  " Symbol for modified file
		let stat .= getbufvar(a:bufnum, '&readonly') ? '✗'  : ' '   " Symbol for read-only file

		let stat .= '%='
		let stat .= ' %Y  '  " File type
		let stat .= encoding . ' ' . fileformat .' '
		let stat .= (getbufvar(a:bufnum, '&expandtab') == 'expandtab' ? '⇥' : '˽') . ' ' . getbufvar(a:bufnum, '&tabstop') . ' '

		if a:active
			let stat .= modeinfo[1]
		endif

		let stat .= ' %5l %2v %3p%%'  " Line number, column number, percentage through file
		let stat .= '%*'  " Reset color
		return stat
	endfunction

	function! s:RefreshStatus()
		for nr in range(1, winnr('$'))
			call setwinvar(nr, '&statusline', '%!BuildStatusLine(' . winbufnr(nr) . ',' . (nr == winnr()) . ')')
		endfor
	endfunction

	function! s:RefreshCurrent()
		call setwinvar(winnr(), '&statusline', '%!BuildStatusLine(' . winnr() . ')')
	endfunction

	augroup status
		autocmd!
		autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
		au InsertEnter,InsertLeave call <SID>RefreshCurrent()
	augroup END
" }}

" Plugins {{
	" CtrlP {{
		" Open CtrlP in MRU mode by default
		let g:ctrlp_cmd = 'CtrlPMRU'
	" }}
	" Fugitive {{
		nnoremap <silent> <Leader>gs :Gstatus<CR>
		nnoremap <silent> <Leader>gd :Gdiff<CR>
		nnoremap <silent> <Leader>gc :Gcommit<CR>
		nnoremap <silent> <Leader>gb :Gblame<CR>
		nnoremap <silent> <Leader>gl :Glog<CR>
		nnoremap <silent> <Leader>gp :Git push<CR>
		nnoremap <silent> <Leader>gr :Gread<CR>
		nnoremap <silent> <Leader>gw :Gwrite<CR>
		nnoremap <silent> <Leader>ge :Gedit<CR>
		nnoremap <silent> <Leader>ga :Git add -p %<CR>
	"}}
	" Goyo {{
		" Toggle distraction-free mode with ,F:
		nnoremap <silent> <Leader>F :Goyo<CR>
		function! s:goyo_enter()
			if has('gui_macvim')
				set fullscreen
				set guifont=Monaco:h14
				set linespace=7
				set guioptions-=r " hide right scrollbar
			endif
			set wrap
			set noshowcmd
			Limelight
		endfunction

		function! s:goyo_leave()
			if has('gui_macvim')
				set nofullscreen
				set guifont=Monaco:h14
				set linespace=0
				set guioptions+=r
			endif
			set nowrap
			set showcmd
			Limelight!
		endfunction

		autocmd! User GoyoEnter
		autocmd! User GoyoLeave
		autocmd  User GoyoEnter call <SID>goyo_enter()
		autocmd  User GoyoLeave call <SID>goyo_leave()
	" }}
	" Ledger {{
		let g:ledger_maxwidth = 70
		let g:ledger_fillstring = '    ·'
		" let g:ledger_detailed_first = 1:
		" Toggle transaction state with <space>:
		au FileType ledger nnoremap <silent> <Space> :call ledger#transaction_state_toggle(line('.'), '* !')<CR>
		" Use ctrl-x to autocomplete:
		au FileType ledger inoremap <silent> <C-x> <C-x><C-o>
		au FileType ledger nnoremap <silent> <C-t> :exe 'read !ledger entry --file '.shellescape(expand("%"), 1).' '.shellescape(expand("<cWORD>"), 1)<CR>
	" }}
	" Tagbar {{
		" Use F9 to toggle tag bar:
		nnoremap <silent> <F9> :TagbarToggle<CR>
	" }}
	" Undotree {{
		" Use F8 to toggle undo tree:
		nnoremap <silent> <F8> :UndotreeToggle<CR>
	" }}
" }}

