" Find all occurrences of a pattern in a file.
fun! lf_find#buffer(pattern)
  if getbufvar(winbufnr(winnr()), "&ft") ==# "qf"
    call s:warningMessage("Cannot search the quickfix window")
    return
  endif
  try
    silent noautocmd execute "lvimgrep /" . a:pattern . "/gj " . fnameescape(expand("%"))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  lwindow
endf

" Find all occurrences of a pattern in all open files.
fun! lf_find#all_buffers(pattern)
  " Get the list of open files
  let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'fnameescape(bufname(v:val))')
  try
    silent noautocmd execute "vimgrep /" . a:pattern . "/gj " . join(l:files)
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  cwindow
endf


