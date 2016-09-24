compiler context

" Better auto-completion for things like '\in{...}[fig:...]'
setlocal iskeyword+=:
" See :h tex-conceal
setlocal conceallevel=2
setlocal omnifunc=syntaxcomplete#Complete
let g:omni_syntax_group_include_context='mf\w\+,mp\w\+'

" Typeset with ConTeXt MKIV
nnoremap <silent><buffer> <leader>tt :<c-u>update<cr>:ConTeXt<cr>
" Clean generated files:
nnoremap <silent><buffer> <leader>tc :<c-u>call lf_tex#clean()<cr>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <leader>tv :<c-u>call lf_tex#preview()<cr>
" Forward search using Skim:
nnoremap <silent><buffer> <leader>ts :<c-u>call lf_tex#forward_search()<cr>

let s:tp_regex = '?^$\|^\s*\(\\item\|\\start\|\\stop\|\\blank\)'

fun! s:tp()
  call cursor(search(s:tp_regex, 'bcW')+1, 1)
  normal! V
  call cursor(search(s:tp_regex, 'W')-1, 1)
endf

" Reflow paragraph with gqtp ("gq TeX paragraph")
omap     <silent><buffer> tp :<c-u>call <sid>tp()<cr>
" Select TeX paragraph
vnoremap <silent><buffer> tp <esc>:<c-u>call <sid>tp()<cr>

" $...$ text object
onoremap <silent><buffer> i$ :<c-u>normal! T$vt$<cr>
onoremap <silent><buffer> a$ :<c-u>normal! F$vf$<cr>
vnoremap <buffer> i$ T$ot$
vnoremap <buffer> a$ F$of$

command! -nargs=0 ConTeXt execute 'lcd' fnameescape(expand('%:p:h'))<bar>
      \ call lf_msg#notice('Typesetting...')<bar>
      \ call lf_job#start([
      \ "/bin/sh", "-c", "PATH=$HOME/Applications/ConTeXt-Beta/tex/texmf-osx-64/bin:$PATH mtxrun --script context --autogenerate --nonstopmode --synctex=1 ".expand('%:t')
      \ ], 'lf_tex#callback')

