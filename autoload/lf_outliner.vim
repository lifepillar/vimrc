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

fun! lf_outliner#enable()
  setlocal autoindent
  setlocal formatoptions=tcqrn1jo
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

