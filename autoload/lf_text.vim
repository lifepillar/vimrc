fun! s:enableSoftWrap()
  setlocal wrap
  map <buffer> j gj
  map <buffer> k gk
  echomsg "Soft wrap enabled"
endf

fun! s:disableSoftWrap()
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
    call s:disableSoftWrap()
  else
    call s:enableSoftWrap()
  endif
endf

" Delete trailing white space.
fun! lf_text#removeTrailingSpace()
  let l:winview = winsaveview() " Save window state
  %s/\s\+$//ge
  call winrestview(l:winview) " Restore window state
  call s:updateWarnings()
  redraw  " See :h :echo-redraw
  echomsg 'Trailing space removed!'
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

