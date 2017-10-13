fun! s:load_cscope_db()
  let l:db = findfile("cscope.out", ".;") " See :h findfile()
  if !empty(l:db)
    execute "cscope add" fnameescape(l:db)
  endif
  return !empty(l:db)
endf

" Cscope
if s:load_cscope_db()
  nnoremap <buffer> <silent> <leader>ca :<c-u>cs find a <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <buffer> <silent> <leader>cc :<c-u>cs find c <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <buffer> <silent> <leader>cd :<c-u>cs find d <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <buffer> <silent> <leader>ce :<c-u>cs find e <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <buffer> <silent> <leader>cf :<c-u>cs find f <c-r>=fnameescape(expand("<cfile>"))<cr><cr>
  nnoremap <buffer> <silent> <leader>cg :<c-u>cs find g <c-r>=fnameescape(expand("<cword>"))<cr><cr>
  nnoremap <buffer> <silent> <leader>ci :<c-u>cs find i ^<c-r>=fnameescape(expand("<cfile>"))<cr><cr>:bo cwindow<cr>
  nnoremap <buffer> <silent> <leader>cs :<c-u>cs find s <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
  nnoremap <buffer> <silent> <leader>ct :<c-u>cs find t <c-r>=fnameescape(expand("<cword>"))<cr><cr>:bo cwindow<cr>
endif
