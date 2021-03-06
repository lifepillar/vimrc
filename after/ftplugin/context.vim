" Better auto-completion for things like '\in{...}[fig:...]'
setlocal iskeyword+=:

" Typeset with ConTeXt MKIV
nnoremap <silent><buffer> <leader>tt :<c-u>update<cr>:ConTeXt<cr>
" Clean generated files:
nnoremap <silent><buffer> <leader>tc :<c-u>call local#tex#clean()<cr>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <leader>tv :<c-u>call local#tex#preview()<cr>
" Forward search using Skim:
nnoremap <silent><buffer> <leader>ts :<c-u>call local#tex#forward_search()<cr>

" Use ConTeXt Beta by default
let g:context_mtxrun = 'PATH=$HOME/Applications/context-osx-64/tex/texmf-osx-64/bin:$PATH mtxrun'
let g:context_synctex = 1

call local#text#load_snippets()
