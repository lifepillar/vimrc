fun! lf_cheatsheet#open()
  botright vert 40sview ${HOME}/.vim/cheatsheet.txt
  setlocal bufhidden=wipe nobuflisted noswapfile nowrap
  nnoremap <silent> <buffer> <tab> <c-w><c-w>
  nnoremap <silent> <buffer> q <c-w>c
endf

