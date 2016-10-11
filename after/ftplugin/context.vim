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

" Use ConTeXt Beta by default
let g:context_mtxrun = 'PATH=$HOME/Applications/ConTeXt-Beta/tex/texmf-osx-64/bin:$PATH mtxrun'
