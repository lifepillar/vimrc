fun! lf_text#enableSoftWrap()
  setlocal wrap
  map <buffer> j gj
  map <buffer> k gk
  echomsg "Soft wrap enabled"
endf

fun! lf_text#disableSoftWrap()
  setlocal nowrap
  if mapcheck("j") != ""
    unmap <buffer> j
    unmap <buffer> k
  endif
  echomsg "Soft wrap disabled"
endf

" Toggle soft-wrapped text in the current buffer.
fun! lf_text#toggleWrap()
  if &l:wrap
    call lf_text#disableSoftWrap()
  else
    call lf_text#enableSoftWrap()
  endif
endf

" Set the tab width in the current buffer (see also http://vim.wikia.com/wiki/Indenting_source_code).
fun! lf_text#set_tab_width(w)
  let l:twd = a:w > 0 ? a:w : 1 " Disallow non-positive width
  " For the following assignment, see :help let-&.
  " See also http://stackoverflow.com/questions/12170606/how-to-set-numeric-variables-in-vim-functions.
  let &l:tabstop=l:twd
  let &l:shiftwidth=l:twd
  let &l:softtabstop=l:twd
endf

" Return a List of selected lines.
" If there is an active selection, returns the selected text (the arguments
" are ignored); otherwise, returns the text in the given range.
fun! lf_text#selection(ln1, ln2)
  if getpos("'>") != [0, 0, 0, 0]
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let l:lines = getline(lnum1, lnum2)
    let l:lines[-1] = l:lines[-1][:col2 - 1]
    let l:lines[0] = l:lines[0][col1 - 1:]
    return l:lines
  else
    return getline(a:ln1, a:ln2)
  end
endf

fun! lf_text#diff_orig()
  vert new
  setl buftype=nofile bufhidden=wipe nobuflisted noswapfile
  silent read ++edit #
  norm 0d_
  autocmd BufWinLeave <buffer> diffoff!
  silent file [ORIGINAL]
  diffthis
  wincmd p
  diffthis
endf

fun! lf_text#ctags(args)
  if empty(tagfiles()) " New tags file
    let l:idx = inputlist(["Choose which directory to process:", "1. ".getcwd(), "2. ".expand("%:p:h"), "3. Other"])
    let l:tagdir = (l:idx == 1 ? getcwd() : (l:idx == 2 ? expand("%:p:h") : (l:idx == 3 ? fnamemodify(input("Directory: ", "", "file"), ':p') : "")))
  elseif len(tagfiles()) == 1 " Update unique tags file
    let l:tagdir = fnamemodify(tagfiles()[0], ':h')
  else " Choose among several tags files
    let l:idx = inputlist(map(copy(tagfiles()), {k,v -> k.'. '.v}))
    let l:tagdir = (empty(l:idx) || l:idx < 0 || l:idx >= len(tagfiles()) ? "" : fnamemodify(tagfiles()[l:idx], ':h'))
  endif
  if empty(l:tagdir) 
    call lf_msg#notice("Cancelled.")
    return
  elseif !isdirectory(l:tagdir)
    call lf_msg#warn("Directory does not exist.") 
    return 
  endif
  let l:tagfile = l:tagdir."/tags"
  call lf_msg#notice('Updating ' . l:tagfile)
  let s:res = lf_job#start(['ctags',
        \ '-R',
        \ '--sort=foldcase',
        \ '--extra=+fq',
        \ '--fields=+iaS',
        \ '--c++-kinds=+p',
        \ '--exclude=cache',
        \ '--exclude=third_party',
        \ '--exclude=tmp',
        \ '--exclude=*.html',
        \ '-o',
        \ l:tagfile] + split(a:args) + [l:tagdir])
endf

