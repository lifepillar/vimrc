compiler tex

" Better auto-completion for things like '\label{fig:...'
set iskeyword+=:

" Typeset with LuaLaTeX
nnoremap <silent> <leader>tt :<c-u>update<cr>:LuaLaTeX<cr>
" Clean generated files:
nnoremap <expr><silent><buffer> <leader>tc lf_tex#clean()
" Open PDF previewer (Skim):
nnoremap <expr><silent><buffer> <leader>tv lf_tex#preview()
" Forward search using Skim:
nnoremap <expr><silent><buffer> <leader>ts lf_tex#forward_search()
" Reflow paragraph with gqtp ("gq TeX paragraph")
" See http://vim.wikia.com/wiki/Formatting_paragraphs_in_LaTeX:_an_%22environment-aware_gqap%22
omap <buffer> tp ?^$\\|^\s*\(\\item\\|\\begin\\|\\end\\|\\label\)?1<cr>//-1<cr>.<cr>

let g:latexmk = split('latexmk -lualatex -cd -pv- -synctex=1 -file-line-error -interaction=nonstopmode')

command! -nargs=0 LuaLaTeX call lf_shell#async_run(g:latexmk+[expand('%:p')], 'lf_tex#callback')

