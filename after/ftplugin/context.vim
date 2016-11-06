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
iab <buffer> ch… \startchapter[title={<c-o>ma}]<cr><c-o>mb<cr>\stopchapter<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>
iab <buffer> s… \startsection[title={<c-o>ma}]<cr><c-o>mb<cr>\stopsection<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>
iab <buffer> ss… \startsubsection[title={<c-o>ma}]<cr><c-o>mb<cr>\stopsubsection<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>
iab <buffer> sss… \startsubsubsection[title={<c-o>ma}]<cr><c-o>mb<cr>\stopsubsubsection<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>
iab <buffer> slide… \startslide[title={<c-o>ma}]<cr><c-o>mb<cr>\stopslide<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>
iab <buffer> fig… \startplacefigure<cr><tab>\externalfigure[<c-o>ma]%<cr>[]<c-o>mb<cr><c-d>\stopplacefigure<esc>`a`b<c-o>a<c-r>=lf_text#eatchar('\s')<cr>
iab <buffer> item… \startitemize<cr><cr>\stopitemize<up><tab>\item
iab <buffer> enum… \startitemize[n]<cr><cr>\stopitemize<up><tab>\item
iab <buffer> i… \item
