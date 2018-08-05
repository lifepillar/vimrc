" Send the output of a Vim command to a new scratch buffer
fun! lf_buffer#vim_cmd(cmd)
  botright new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ noswapfile\ nowrap
  call append(0, split(execute(a:cmd), "\n"))
endf

" Send the output of a shell command to a new scratch buffer
" cwd: change local directory to cwd before running the command
" args: a List whose first item is the command name and the remaining items are
" the command's arguments
" open: a Vim command specifying where the window should be opened
fun! lf_buffer#cmd(cwd, args, open) abort
  let l:cmd = join(map(a:args, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'))
  execute a:open "new"
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute 'lcd' a:cwd
  execute '%!' l:cmd
endf

" Ignore syntax highlighting, filetype, etc…
" See also: http://vim.wikia.com/wiki/Faster_loading_of_large_files
fun! lf_buffer#large(name)
  let b:lf_large_file = 1
  syntax clear
  set eventignore+=FileType
  let &backupskip = join(add(split(&backupskip, ','), a:name), ',')
  setlocal foldmethod=manual nofoldenable noswapfile noundofile
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

" Delete all buffers except the current one
fun! lf_buffer#delete_others()
  let l:bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  execute (bufnr('') > l:bl[0] ? 'confirm '.l:bl[0].',.-bd' : '') (bufnr('') < l:bl[-1] ? '|confirm .+,$bd' : '')
endf

" Wipe all buffers except the current one
fun! lf_buffer#wipe_others()
  let l:min = min(filter(range(1, bufnr('$')), 'bufexists(v:val)'))
  execute (bufnr('') > l:min ? 'confirm '.l:min.',.-bw' : '') (bufnr('') < bufnr('$') ? '|confirm .+,$bw' : '')
endf

" Clear (delete the content) of the given buffer.
fun! lf_buffer#clear(file_pattern)
  if bufnr(a:file_pattern) > -1
    silent execute bufnr(a:file_pattern) 'bufdo' '1,$delete'
    silent execute 'buffer' bufnr(@#)
  endif
endf
