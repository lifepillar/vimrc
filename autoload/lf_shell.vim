let s:winpos_map = {
      \ "T": "to new",  "t": "abo new", "B": "bo new",  "b": "bel new",
      \ "L": "to vnew", "l": "abo vnew", "R": "bo vnew", "r": "bel vnew"
      \ }

" Run an external command and display its output in a new buffer.
"
" cmdline: the command to be executed;
" pos: a letter specifying the position of the output window (see s:winpos_map).
"
" See http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
" See also https://groups.google.com/forum/#!topic/vim_use/4ZejMpt7TeU
fun! lf_shell#run(cmdline, pos) abort
  let l:cmd = ""
  for l:part in split(a:cmdline, ' ')
    if l:part =~ '\v^[%#<]'
      let l:expanded_part = expand(l:part)
      let l:cmd .= ' ' . (l:expanded_part == "" ? l:part : shellescape(l:expanded_part))
    else
      let l:cmd .= ' ' . l:part
    endif
  endfor
  execute get(s:winpos_map, a:pos, "bo new")
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute '%!'. l:cmd
  setlocal nomodifiable
  nnoremap <silent> <buffer> <tab> <c-w><c-w>
  nnoremap <silent> <buffer> q <c-w>c
  " Uncomment the following line for debugging
  " echomsg cmd
  1
endf


