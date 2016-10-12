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
    let l:lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
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
  norm ggd_
  autocmd BufWinLeave <buffer> diffoff!
  silent file [ORIGINAL]
  diffthis
  wincmd p
  diffthis
endf

" Chained completion that works as I want! {{{
let s:compl_map = {
      \ 'defs'    :  "\<c-x>\<c-d>",
      \ 'dict'    :  "\<c-x>\<c-k>",
      \ 'incl'    :  "\<c-x>\<c-i>",
      \ 'keyn'    :  "\<c-x>\<c-n>",
      \ 'keyp'    :  "\<c-x>\<c-p>",
      \ 'omni'    :  "\<c-x>\<c-o>",
      \ 'tags'    :  "\<c-x>\<c-]>",
      \ 'user'    :  "\<c-x>\<c-u>"
      \ }

let s:can_complete = {
      \ 'defs'    :  { -> 1 },
      \ 'dict'    :  { -> strlen(&l:dictionary) > 0 },
      \ 'incl'    :  { -> 1 },
      \ 'keyn'    :  { -> 1 },
      \ 'keyp'    :  { -> 1 },
      \ 'omni'    :  { -> strlen(&l:omnifunc) > 0 },
      \ 'tags'    :  { -> !empty(tagfiles()) },
      \ 'user'    :  { -> strlen(&l:completefunc) > 0 }
      \ }

let s:compl_method = []

" Workhorse function for chained completion. Do not call directly.
fun! lf_text#complete_chain(index)
  let i = a:index
  while i < len(s:compl_method) && !s:can_complete[s:compl_method[i]]()
    let i += 1
  endwhile
  if i < len(s:compl_method)
    return s:compl_map[s:compl_method[i]] .
          \ "\<c-r>=pumvisible()?'':lf_text#complete_chain(".(i+1).")\<cr>"
  endif
  return ''
endf

fun! s:complete(dir)
  let s:compl_method = get(b:, 'completion_methods', ['omni', 'incl', 'tags', 'dict'])
  if a:dir == -1
    call reverse(s:compl_method)
  endif
  return lf_text#complete_chain(0)
endf

fun! lf_text#complete(dir)
  return pumvisible()
        \ ? (a:dir == -1 ? "\<c-p>" : "\<c-n>")
        \ : col('.')>1 && (matchstr(getline('.'), '\%' . (col('.')-1) . 'c.') =~ '\s')
        \   ? (a:dir == -1 ? "\<c-d>" : "\<tab>")
        \   : get(b:, 'lf_tab_complete', s:complete(a:dir))
endf
" }}}

" vim: sw=2 fdm=marker
