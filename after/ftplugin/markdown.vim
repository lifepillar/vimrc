setlocal autoindent
setlocal completefunc=CompleteInternalLink
setlocal conceallevel=2
setlocal dictionary=/usr/share/dict/words
" Enable completion after [[:
setlocal iskeyword+=[
" Disable HTML completion function set by the Markdown plugin:
setlocal omnifunc=
setlocal path=.,**3/
setlocal spell
setlocal spelllang=en
setlocal suffixesadd=.md
setlocal textwidth=80
setlocal wrap

" Partially inspired by https://vimways.org/2019/personal-notetaking-in-vim/

fun markdown#set_arglist(result)
  execute "args" join(map(a:result, 'fnameescape(v:val) .. ".md"'))
endf

" Search notes in the current directory
nnoremap <silent> <buffer> <leader>n :<c-u>call zeef#open(<sid>get_notes(''), 'markdown#set_arglist', 'Select notes')<cr>

fun s:get_notes(base)
  return map(glob(printf('**/%s*.md', a:base), 1, 1, 0), 'fnamemodify(v:val, ":r")')
endf

" Suggest notes (i.e., Markdown files) in the current directory after [[.
fun CompleteInternalLink(findstart, base)
  if a:findstart
    let l:col = match(getline('.'), '[[\zs\S*\%' .. col('.') .. 'c')
    return l:col == -1 ? -3 : l:col
  else
    let s:matches = s:get_notes(a:base)
    return map(s:matches, '{"word": fnamemodify(v:val, ":t"), "abbr": v:val}')
  endif
endf

let b:mucomplete_chain = ['user', 'path', 'keyn', 'dict', 'uspl']

let s:root = finddir("Notes", ".;")
execute "lcd" (empty(s:root) ? "%:h" : s:root)
unlet s:root

call lf_text#load_snippets()
