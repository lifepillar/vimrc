compiler context

" Better auto-completion for things like '\in{...}[fig:...]'
set iskeyword+=:

" Typeset with ConTeXt MKIV
nnoremap       <silent><buffer> <leader>tt :<c-u>update<cr>:ConTeXt<cr>
" Clean generated files:
nnoremap <expr><silent><buffer> <leader>tc lf_tex#clean()
" Open PDF previewer (Skim):
nnoremap <expr><silent><buffer> <leader>tv lf_tex#preview()
" Forward search using Skim:
nnoremap <expr><silent><buffer> <leader>ts lf_tex#forward_search()
" Reflow paragraph with gqtp ("gq TeX paragraph")
" See http://vim.wikia.com/wiki/Formatting_paragraphs_in_LaTeX:_an_%22environment-aware_gqap%22
omap     <silent><buffer> tp      ?^$\\|^\s*\(\\item\\|\\start\\|\\stop\\|\\blank\)?1<cr>//-1<cr>.<cr>
vnoremap <silent><buffer> tp <esc>?^$\\|^\s*\(\\item\\|\\start\\|\\stop\\|\\blank\)?1<cr>V//-1<cr>
" $...$ text object
onoremap <silent><buffer> i$ :<c-u>normal! T$vt$<cr>
onoremap <silent><buffer> a$ :<c-u>normal! F$vf$<cr>
vnoremap <buffer> i$ T$ot$
vnoremap <buffer> a$ F$of$

let g:context_mkiv = split('mtxrun --script context --nonstopmode --synctex=1')

command! -nargs=0 ConTeXt execute 'lcd' fnameescape(expand('%:p:h'))<bar>
      \ call lf_msg#notice('Typesetting...')<bar>
      \ call lf_shell#async_run(g:context_mkiv+[expand('%:t')], 'lf_tex#callback')

