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

