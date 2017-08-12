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

" Returns the currently selected text as a List.
fun! lf_text#selection()
  if getpos("'>") != [0, 0, 0, 0]
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let l:lines = getline(lnum1, lnum2)
    let l:lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let l:lines[0] = l:lines[0][col1 - 1:]
    return l:lines
  else
    call lf_msg#warn("No selection markers")
    return []
  end
endf

fun! lf_text#diff_orig()
  vert new
  setl buftype=nofile bufhidden=wipe nobuflisted noswapfile
  silent read ++edit #
  norm ggd_
  autocmd BufWinLeave <buffer> diffoff!
  silent file [ORIGINAL]
  diffthis
  wincmd p
  diffthis
endf

fun! lf_text#eatchar(pat) " See :h abbreviations
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" Comment out the specified line by wrapping it with the given comment delimiters.
fun! lf_text#comment_line(lnum, ldelim, rdelim, indent)
  let l:lc = escape(a:ldelim, '\/*~$.')
  let l:rc = escape(a:rdelim, '\/*~$.')
  call setline(a:lnum, substitute(getline(a:lnum), '^\(\s\{'.a:indent.'}\)\(.*\)$', '\1'.l:lc.' \2'.(empty(l:rc) ? '' : ' '.l:rc), ''))
endf

" Uncomment the specified line by removing the given comment delimiters.
fun! lf_text#uncomment_line(lnum, ldelim, rdelim)
  let l:lc = escape(a:ldelim, '\/*~$.')
  let l:rc = escape(a:rdelim, '\/*~$.')
  call setline(a:lnum, substitute(substitute(getline(a:lnum), '\s*'.l:rc.'\s*$', '', ''), '^\(\s*\)'.l:lc.'\s\?\(.*\)$', '\1\2', ''))
endf

fun! lf_text#comment_delimiters()
  let l:delim = split(&l:commentstring, '\s*%s\s*')
  if empty(l:delim)
    call lf_msg#err('Undefined comment delimiters. Please setlocal commentstring.')
    return ['','']
  endif
  if len(l:delim) < 2
    call add(l:delim, '')
  endif
  return l:delim
endf

fun! lf_text#minindent(first, last)
  let [l:min, l:i] = [indent(a:first), a:first + 1]
  while l:min > 0 && l:i <= a:last
    if l:min > indent(l:i)
      let l:min = indent(l:i)
    endif
    let l:i += 1
  endwhile
  return l:min
endf

fun! lf_text#comment_out(type, ...) abort " See :h map-operator
  let l:delim = lf_text#comment_delimiters()
  let [l:firstline, l:lastline] = a:0 ? [line("'<"), line("'>")] : [line("'["), line("']")]
  let l:indent = lf_text#minindent(l:firstline, l:lastline)
  let l:lnum = l:firstline
  while l:lnum <= l:lastline
    call lf_text#comment_line(l:lnum, l:delim[0], l:delim[1], l:indent)
    let l:lnum += 1
  endwhile
endf

fun! lf_text#uncomment(type, ...) abort
  let l:delim = lf_text#comment_delimiters()
  let [l:firstline, l:lastline] = a:0 ? [line("'<"), line("'>")] : [line("'["), line("']")]
  let l:lnum = l:firstline
  while l:lnum <= l:lastline
    call lf_text#uncomment_line(l:lnum, l:delim[0], l:delim[1])
    let l:lnum += 1
  endwhile
  " TODO: reindent?
endf
