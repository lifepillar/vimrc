compiler tex

" Better auto-completion for things like '\label{fig:...'
set iskeyword+=:
" See :h tex-conceal
setlocal conceallevel=2

" Typeset with LuaLaTeX
nnoremap <silent><buffer> <leader>tt :<c-u>update<cr>:LuaLaTeX<cr>
" Clean generated files:
nnoremap <silent><buffer> <leader>tc :<c-u>call lf_tex#clean()<cr>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <leader>tv :<c-u>call lf_tex#preview()<cr>
" Forward search using Skim:
nnoremap <silent><buffer> <leader>ts :<c-u>call lf_tex#forward_search()<cr>
" Reflow paragraph with gqtp ("gq TeX paragraph")
" See http://vim.wikia.com/wiki/Formatting_paragraphs_in_LaTeX:_an_%22environment-aware_gqap%22
omap     <silent><buffer> tp      ?^$\\|^\s*\(\\item\\|\\begin\\|\\end\\|\\\(sub\)*section\\|\\label\\|\(small\\|med\\|big\)skip\)?1<cr>//-1<cr>.<cr>
vnoremap <silent><buffer> tp <esc>?^$\\|^\s*\(\\item\\|\\begin\\|\\end\\|\\\(sub\)*section\\|\\label\\|\(small\\|med\\|big\)skip\)?1<cr>V//-1<cr>
" $...$ text object
onoremap <silent><buffer> i$ :<c-u>normal! T$vt$<cr>
onoremap <silent><buffer> a$ :<c-u>normal! F$vf$<cr>
vnoremap <buffer> i$ T$ot$
vnoremap <buffer> a$ F$of$

let g:latexmk = split('latexmk -lualatex -cd -pv- -synctex=1 -file-line-error -interaction=nonstopmode')

command! -nargs=0 LuaLaTeX call lf_msg#notice('Typesetting...')<bar>
      \ call lf_shell#async_run(g:latexmk+[expand('%:p')], 'lf_tex#callback')

