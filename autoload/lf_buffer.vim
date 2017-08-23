" Send the output of a Vim command to a new scratch buffer
fun! lf_buffer#cmd(cmd)
  botright new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ noswapfile\ nowrap
  call append(0, split(execute(a:cmd), "\n"))
endf

" Ignore syntax highlighting, filetype, etc…
" See also: http://vim.wikia.com/wiki/Faster_loading_of_large_files
fun! lf_buffer#large(name)
  let b:lf_large_file = 1
  syntax clear
  set eventignore+=FileType
  let &backupskip = join(add(split(&backupskip, ','), a:name), ',')
  setlocal foldmethod=manual nofoldenable noswapfile
  augroup lf_large_buffer
    autocmd!
    autocmd BufWinEnter <buffer> call <sid>restore_eventignore()
  augroup END
endf

fun! s:restore_eventignore()
  set eventignore-=FileType
  autocmd! lf_large_buffer
  augroup! lf_large_buffer
endf
