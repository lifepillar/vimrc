fun! lf_text#enable_soft_wrap()
  setlocal wrap
  map <buffer> j gj
  map <buffer> k gk
  echomsg "Soft wrap enabled"
endf

fun! lf_text#disable_soft_wrap()
  setlocal nowrap
  if mapcheck("j") != ""
    unmap <buffer> j
    unmap <buffer> k
  endif
  echomsg "Soft wrap disabled"
endf

" Toggle soft-wrapped text in the current buffer.
fun! lf_text#toggle_wrap()
  if &l:wrap
    call lf_text#disable_soft_wrap()
  else
    call lf_text#enable_soft_wrap()
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

fun! lf_text#diff_orig() " See :help :DiffOrig
  vert new
  setl buftype=nofile bufhidden=wipe nobuflisted noswapfile
  silent read ++edit #
  norm ggd_
  execute "setfiletype" getbufvar("#", "&ft")
  autocmd BufWinLeave <buffer> diffoff!
  diffthis
  wincmd p
  diffthis
endf

fun! lf_text#eatchar(pat) " See :h abbreviations
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" Returns a pair of comment delimiters, extracted from 'commentstring'.
" The delimiters are ready to be used in a regular expression.
fun! lf_text#comment_delimiters()
  let l:delim = split(&l:commentstring, '\s*%s\s*')
  if empty(l:delim)
    call lf_msg#err('Undefined comment delimiters. Please setlocal commentstring.')
    return ['','']
  endif
  if len(l:delim) < 2
    call add(l:delim, '')
  endif
  return [escape(l:delim[0], '\/*~$.'), escape(l:delim[1], '\/*~$.')]
endf

" Comment out a region of text. Assumes that the delimiters are properly escaped.
fun! lf_text#comment_out(first, last, lc, rc) abort
  let l:indent = s:minindent(a:first, a:last)
  for l:lnum in range(a:first, a:last)
    call setline(l:lnum, substitute(getline(l:lnum), '^\(\s\{'.l:indent.'}\)\(.*\)$', '\1'.a:lc.' \2'.(empty(a:rc) ? '' : ' '.a:rc), ''))
  endfor
endf

" Uncomment a region of text. Assumes that the delimiters are properly escaped.
fun! lf_text#uncomment(first, last, lc, rc) abort
  for l:lnum in range(a:first, a:last)
    call setline(l:lnum, substitute(substitute(getline(l:lnum), '\s*'.a:rc.'\s*$', '', ''), '^\(\s*\)'.a:lc.'\s\?\(.*\)$', '\1\2', ''))
  endfor
endf

" Comment/uncomment a region of text.
fun! lf_text#toggle_comment(type, ...) abort " See :h map-operator
  let [l:lc, l:rc] = lf_text#comment_delimiters()
  let [l:first, l:last] = a:0 ? [line("'<"), line("'>")] : [line("'["), line("']")]
  if match(getline(l:first), '^\s*'.l:lc) > -1
    call lf_text#uncomment(l:first, l:last, l:lc, l:rc)
  else
    call lf_text#comment_out(l:first, l:last, l:lc, l:rc)
  endif
endf

fun! s:minindent(first, last)
  let [l:min, l:i] = [indent(a:first), a:first + 1]
  while l:min > 0 && l:i <= a:last
    if l:min > indent(l:i)
      let l:min = indent(l:i)
    endif
    let l:i += 1
  endwhile
  return l:min
endf

" Poor man's snippet generator in two functions.
"
" Snippets are collected in plain text files named after the file type.
" Example snippet:
"
" snippet for
" for (___) {
"   ___
" }
"
" A snippet definition starts with the `snippet' keyword followed by the name
" of the snippet (for). The remaining lines contain the text that must be put
" (verbatim) into the buffer (see the snippets folder for other examples).
"
" Three underscore are used for placeholders. At least one placeholder must be
" present. The cursor is put at the first placeholder after expanding the
" snippet. You can jump to the next placeholder by pressing ctrl-b in Insert
" mode.
"
" To expand a snippet, type its name followed by … (alt-. in macOS).
fun! lf_text#load_snippets()
  let l:file = readfile($HOME.'/.vim/snippets/'.&ft.'.txt')
  let b:lf_snippets = {}
  for l:line in l:file
    if l:line =~ '^snippet'
      let l:key = matchstr(l:line, '^snippet\s\+\zs.\+$')
      let b:lf_snippets[l:key] = []
    elseif !empty(l:line)
      call add(b:lf_snippets[l:key], l:line)
    endif
  endfor
  " Start inserting at the next placeholder
  inoremap <buffer> <c-b> <esc>gn"_c
endf

fun! lf_text#expand_snippet()
  " Get word in front of the cursor and tail of line
  let l:match = matchlist(getline('.'), '\(\S\+\%'.col('.').'c\)\(.*\)$')
  if empty(l:match) | return '…' | endif
    let [l:key, l:tail] = [l:match[1], l:match[2]]
    let l:snippet = get(b:lf_snippets, l:key, [])
  if !empty(l:snippet) " Expand snippet
    let l:indent = matchstr(getline('.'), '^\s\+')
    call setline('.', l:indent . l:snippet[0])
    call append('.', map(l:snippet[1:-1], { _,t -> l:indent . t}))
    call search('___', 'csW')
    let l:save_cursor = getcurpos()
    " Enable searching for ___ with // and ?? and replacing the next ___ with gnc:
    let @/ = '___'
    execute '.s/\(\s\?\)___/\1'.l:tail.'/'
    call setpos('.', l:save_cursor)
    return ''
  endif
  return '…'
endf
