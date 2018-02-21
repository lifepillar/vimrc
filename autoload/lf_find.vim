" Find all occurrences of a pattern in a file.
fun! lf_find#buffer(pattern)
  if getbufvar(winbufnr(winnr()), "&ft") ==# "qf"
    call lf_msg#warn("Cannot search the quickfix window")
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
  let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val) && !empty(bufname(v:val))'), 'fnameescape(bufname(v:val))')
  cexpr [] " Clear quickfix list
  try
    for l:file in l:files
      silent noautocmd execute "vimgrepadd /" . a:pattern . "/gj" fnameescape(l:file)
    endfor
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  bo cwindow
endf

fun! lf_find#choose_dir(...) " ... is an optional prompt
  let l:idx = inputlist([get(a:000, 0, "Change directory to:"), "1. ".getcwd(), "2. ".expand("%:p:h"), "3. Other"])
  let l:dir = (l:idx == 1 ? getcwd() : (l:idx == 2 ? expand("%:p:h") : (l:idx == 3 ? fnamemodify(input("Directory: ", "", "file"), ':p') : "")))
  if strlen(l:dir) <= 0
    call lf_msg#notice("Cancelled.")
    return ''
  endif
  return l:dir
endf

fun! lf_find#grep(args)
  if getcwd() != expand("%:p:h")
    let l:dir = lf_find#choose_dir()
    if empty(l:dir) | return | endif
    execute 'lcd' l:dir
  endif
  execute 'silent grep!' a:args
  bo cwindow
  redraw!
endf

fun! s:get_fzf_output(inpath, outpath, callback, channel, status)
  let l:output = filereadable(a:outpath) ? readfile(a:outpath) : []
  silent! call delete(a:outpath)
  silent! call delete(a:inpath)
  call function(a:callback)(l:output)
endf

" Filter a list and return a List of selected items.
" 'input' is either a shell command that sends its output, one item per line,
" to stdout, or a List of items to be filtered.
fun! lf_find#fuzzy(input, callback, prompt)
  if type(a:input) == v:t_string
    let l:cmd = a:input
    let l:inpath = ''
  else " Assume List
    let l:inpath = tempname()
    call writefile(a:input, l:inpath)
    let l:cmd  = 'cat '.fnameescape(l:inpath)
  endif
  let l:outpath = tempname()
  let l:cmd .= "|fzf -m --prompt '".a:prompt."> '"
  let l:redir = " >".fnameescape(l:outpath)." 2>/dev/tty"
  if has('gui_running') || (!executable('tput') && has('terminal'))
    botright 15split
    call term_start([&shell, &shellcmdflag, l:cmd.l:redir], {
          \ "term_name": a:prompt,
          \ "curwin": 1,
          \ "term_finish": "close",
          \ "exit_cb": function('s:get_fzf_output', [l:inpath, l:outpath, a:callback])
          \ })
  else
    if executable('tput') && filereadable('/dev/tty') " Cool idea adapted from fzf.vim
      call system(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; '.l:cmd." --height 15 ".l:redir, &lines))
    else
      silent execute '!'.l:cmd.l:redir
    endif
    redraw!
    call s:get_fzf_output(l:inpath, l:outpath, a:callback, -1, v:shell_error)
  endif
endf

fun! s:set_arglist(paths)
  if empty(a:paths) | return | endif
  execute "args" join(map(a:paths, { i,v -> fnameescape(v) }))
endf

" Filter a list of paths and populate the arglist with the selected items.
fun! lf_find#arglist(input_cmd)
  call lf_find#fuzzy(a:input_cmd, 's:set_arglist', 'Choose files')
endf

fun! lf_find#file(...) " ... is an optional directory
  let l:dir = (a:0 > 0 ? ' '.a:1 : ' .')
  call lf_find#arglist(executable('rg') ? 'rg --files'.l:dir : 'find'.l:dir.' -type f')
endf

fun! s:set_colorscheme(colors)
  if empty(a:colors) | return | endif
  execute "colorscheme" a:colors[0]
endf

fun! lf_find#colorscheme()
  let l:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  let l:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , { i,v -> fnamemodify(v, ":t:r") })
  call lf_find#fuzzy(l:colors, 's:set_colorscheme', 'Choose colorscheme')
endf
