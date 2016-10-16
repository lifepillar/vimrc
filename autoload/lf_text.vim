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
" Conditions to be verified for a given method to be applied.
let s:can_complete = {
      \ 'c-n'     :  { t -> 1 },
      \ 'c-p'     :  { t -> 1 },
      \ 'cmd'     :  { t -> 1 },
      \ 'defs'    :  { t -> 1 },
      \ 'dict'    :  { t -> strlen(&l:dictionary) > 0 },
      \ 'file'    :  { t -> t =~# '/' },
      \ 'incl'    :  { t -> 1 },
      \ 'keyn'    :  { t -> 1 },
      \ 'keyp'    :  { t -> 1 },
      \ 'line'    :  { t -> 1 },
      \ 'omni'    :  { t -> strlen(&l:omnifunc) > 0 },
      \ 'spel'    :  { t -> &l:spell },
      \ 'tags'    :  { t -> !empty(tagfiles()) },
      \ 'thes'    :  { t -> strlen(&l:thesaurus) > 0 },
      \ 'user'    :  { t -> strlen(&l:completefunc) > 0 }
      \ }

let g:compl_method = []
let g:compl_text = ''

" Workhorse function for chained completion. Do not call directly.
fun! lf_text#complete_chain(index)
  let i = a:index
  while i < len(g:compl_method) && !s:can_complete[g:compl_method[i]](g:compl_text)
    let i += 1
  endwhile
  if i < len(g:compl_method)
    return s:compl_map[g:compl_method[i]] .
          \ "\<c-r>=pumvisible()?'':lf_text#complete_chain(".(i+1).")\<cr>"
  endif
  return ''
endf

fun! s:complete(dir)
  let g:compl_method = get(b:, 'completion_methods', ['file', 'omni', 'keyn',  'incl', 'tags', 'dict'])
  if a:dir == -1
    call reverse(g:compl_method)
  endif
  return lf_text#complete_chain(0)
endf

fun! lf_text#complete(dir)
  if pumvisible()
    return a:dir == -1 ? "\<c-p>" : "\<c-n>"
  endif
  let g:compl_text = matchstr(strpart(getline('.'), 0, col('.') - 1), '\S\+$')
  return strlen(g:compl_text) == 0
        \ ? (a:dir == -1 ? "\<c-d>" : "\<tab>")
        \ : get(b:, 'lf_tab_complete', s:complete(a:dir))
endf


fun! lf_text#autocomplete()
  if match(strpart(getline('.'), 0, col('.') - 1), '\k\k$') > -1
    silent call feedkeys("\<tab>", 'i')
  endif
endf

let s:completedone = 0

" Note: 'c-n' and 'c-p' use the 'complete' option.
" Note: in 'c-n' and 'c-p' we use the fact that pressing <c-x> while in ctrl-x
" submode doesn't do anything and any key that is not valid in ctrl-x submode
" silently ends that mode (:h complete_CTRL-Y) and inserts the key. Hence,
" after <c-x><c-b>, we are surely out of ctrl-x submode. The subsequent <bs>
" is used to delete the inserted <c-b>. We use <c-b> because it is not mapped
" (:h i_CTRL-B-gone). This trick is needed to have <c-p> trigger keyword
" completion under all circumstances, in particular when the current mode is
" the ctrl-x submode. (pressing <c-p>, say, immediately after <c-x><c-o> would
" do a different thing).
fun! lf_text#enable_autocompletion()
  let s:completedone = 0
  let s:compl_map = {
        \ 'c-n'     :  "\<c-x>\<c-b>\<bs>\<c-n>\<c-p>",
        \ 'c-p'     :  "\<c-x>\<c-b>\<bs>\<c-p>\<c-n>",
        \ 'cmd'     :  "\<c-x>\<c-v>\<c-p>",
        \ 'defs'    :  "\<c-x>\<c-d>\<c-p>",
        \ 'dict'    :  "\<c-x>\<c-k>\<c-p>",
        \ 'file'    :  "\<c-x>\<c-f>\<c-p>",
        \ 'incl'    :  "\<c-x>\<c-i>\<c-p>",
        \ 'keyn'    :  "\<c-x>\<c-n>\<c-p>",
        \ 'keyp'    :  "\<c-x>\<c-p>\<c-n>",
        \ 'line'    :  "\<c-x>\<c-l>\<c-p>",
        \ 'omni'    :  "\<c-x>\<c-o>\<c-p>",
        \ 'spel'    :  "\<c-x>s\<c-p>",
        \ 'tags'    :  "\<c-x>\<c-]>\<c-p>",
        \ 'thes'    :  "\<c-x>\<c-t>\<c-p>",
        \ 'user'    :  "\<c-x>\<c-u>\<c-p>"
        \ }
  augroup lf_completion
    autocmd!
    autocmd TextChangedI * noautocmd if s:completedone | let s:completedone = 0 | else | silent call lf_text#autocomplete() | endif
    autocmd CompleteDone * noautocmd let s:completedone = 1
  augroup END
endf

fun! lf_text#disable_autocompletion()
  if exists('#lf_completion')
    autocmd! lf_completion
    augroup! lf_completion
  endif
  let s:compl_map = {
        \ 'c-n'     :  "\<c-x>\<c-b>\<bs>\<c-n>",
        \ 'c-p'     :  "\<c-x>\<c-b>\<bs>\<c-p>",
        \ 'cmd'     :  "\<c-x>\<c-v>",
        \ 'defs'    :  "\<c-x>\<c-d>",
        \ 'dict'    :  "\<c-x>\<c-k>",
        \ 'file'    :  "\<c-x>\<c-f>",
        \ 'incl'    :  "\<c-x>\<c-i>",
        \ 'line'    :  "\<c-x>\<c-l>",
        \ 'keyn'    :  "\<c-x>\<c-n>",
        \ 'keyp'    :  "\<c-x>\<c-p>",
        \ 'omni'    :  "\<c-x>\<c-o>",
        \ 'spel'    :  "\<c-x>s",
        \ 'tags'    :  "\<c-x>\<c-]>",
        \ 'thes'    :  "\<c-x>\<c-t>",
        \ 'user'    :  "\<c-x>\<c-u>"
        \ }
endf
" }}}

" vim: sw=2 fdm=marker
