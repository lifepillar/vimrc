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
  bo lwindow
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
  bo cwindow
endf

" Filter a list and return a List of selected items.
" input is any shell command that sends its output, one item per line, to stdout,
" or a List of items to be filtered.
fun! lf_find#fuzzy(input)
  if has('gui_running') | call lf_msg#warn('Not implemented') | return [] | endif
  if type(a:input) == v:t_string
    let l:cmd = a:input
  else " Assume List
      let l:input = tempname()
      call writefile(a:input, l:input)
      let l:cmd  = 'cat '.fnameescape(l:input)
  endif
  let l:output = tempname()
  silent execute '!'.l:cmd.'|fzf -m >'.fnameescape(l:output)
  redraw!
  try
    return filereadable(l:output) ? readfile(l:output) : []
  finally
    if exists("l:input")
      silent! call delete(l:input)
    endif
    silent! call delete(l:output)
  endtry
endf

" Filter a list of paths and populate the arglist with the selected items.
fun! lf_find#arglist(input_cmd)
  let l:arglist = lf_find#fuzzy(a:input_cmd)
  if empty(l:arglist) | return | endif
  execute "args" join(map(l:arglist, { i,v -> fnameescape(v) }))
endf

fun! lf_find#colorscheme()
  let l:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colorscheme = lf_find#fuzzy(l:colors)
  if !empty(l:colorscheme)
    execute "colorscheme" l:colorscheme[0]
  endif
endf

