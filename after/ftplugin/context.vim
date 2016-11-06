" Better auto-completion for things like '\in{...}[fig:...]'
setlocal iskeyword+=:

" Typeset with ConTeXt MKIV
nnoremap <silent><buffer> <leader>tt :<c-u>update<cr>:ConTeXt<cr>
" Clean generated files:
nnoremap <silent><buffer> <leader>tc :<c-u>call lf_tex#clean()<cr>
" Open PDF previewer (Skim):
nnoremap <silent><buffer> <leader>tv :<c-u>call lf_tex#preview()<cr>
" Forward search using Skim:
nnoremap <silent><buffer> <leader>ts :<c-u>call lf_tex#forward_search()<cr>

" Use ConTeXt Beta by default
let g:context_mtxrun = 'PATH=$HOME/Applications/ConTeXt-Beta/tex/texmf-osx-64/bin:$PATH mtxrun'
let g:context_synctex = 1

" Useful abbreviations
iab <buffer> ch. \startchapter[title={}]<cr>\stopchapter<up><c-o>f}
iab <buffer> s. \startsection[title={}]<cr>\stopsection<up><c-o>f}
iab <buffer> ss. \startsubsection[title={}]<cr>\stopsubsection<up><c-o>f}
iab <buffer> sss. \startsubsubsection[title={}]<cr>\stopsubsubsection<up><c-o>f}
iab <buffer> slide. \startslide[title={}]<cr>\stopslide<up><c-o>f}
iab <buffer> fig. \startplacefigure<cr><cr>\stopplacefigure<up><tab>\externalfigure[][]<c-o>2<left>
iab <buffer> item. \startitemize<cr><cr>\stopitemize<up><tab>\item
iab <buffer> enum. \startitemize[n]<cr><cr>\stopitemize<up><tab>\item
iab <buffer> i. \item
