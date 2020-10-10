setlocal autoindent
setlocal completefunc=CompleteInternalLink
setlocal conceallevel=2
setlocal dictionary=/usr/share/dict/words
" Enable completion after [[:
setlocal iskeyword+=[
" Disable HTML completion function set by the Markdown plugin:
setlocal omnifunc=
setlocal spell
setlocal spelllang=en
setlocal suffixesadd=.md
setlocal textwidth=80

fun markdown#set_arglist(result)
  execute "args" join(map(a:result, 'fnameescape(v:val) .. ".md"'))
endf

" Search notes in the current directory
nnoremap <silent> <buffer> <leader>n :<c-u>call zeef#open(<sid>get_notes(''), 'markdown#set_arglist', 'Select notes')<cr>

fun s:get_notes(base)
  return map(glob(printf('%s*.md', a:base), 1, 1, 0), 'fnamemodify(v:val, ":r")')
endf

" Suggest notes (i.e., Markdown files) in the current directory after [[.
fun CompleteInternalLink(findstart, base)
  if a:findstart
    let l:col = match(getline('.'), '[[\zs\S*\%' .. col('.') .. 'c')
    return l:col == -1 ? -3 : l:col
  else
    return s:get_notes(a:base)
  endif
endf

let b:mucomplete_chain = ['user', 'path', 'keyn', 'dict', 'uspl']

lcd %:h

call lf_text#load_snippets()
