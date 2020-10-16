" Partially inspired by https://vimways.org/2019/personal-notetaking-in-vim/

fun! local#markdown#set_arglist(result)
  execute "args" join(map(a:result, 'fnameescape(v:val) .. ".md"'))
endf

fun! local#markdown#notes(base)
  return map(glob(printf('**/%s*.md', a:base), 1, 1, 0), 'fnamemodify(v:val, ":r")')
endf

" Suggest notes (i.e., Markdown files) in the current directory after [[.
fun! local#markdown#complete(findstart, base)
  if a:findstart
    let l:col = match(getline('.'), '[[\zs\S*\%' .. col('.') .. 'c')
    return l:col == -1 ? -3 : l:col
  else
    let s:matches = local#markdown#notes(a:base)
    return map(s:matches, '{"word": fnamemodify(v:val, ":t"), "abbr": v:val}')
  endif
endf

fun! local#markdown#fold(lnum)
  return getline(a:lnum) =~# '\m^ \{,3}#\+ \+'
        \ ? '>' .. (1 + indent(a:lnum) / shiftwidth())
        \ : '='
endf

fun! local#markdown#foldtext()
  return getline(v:foldstart)
endf

