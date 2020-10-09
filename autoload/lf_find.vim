" Find all occurrences of a pattern in a file.
fun! lf_find#in_buffer(pattern)
  if getbufvar(winbufnr(winnr()), "&ft") ==# "qf"
    call lf_msg#warn("Cannot search the quickfix window")
    return
  endif
  try
    silent noautocmd execute printf("lvimgrep /%s/gj %s", a:pattern, fnameescape(expand("%")))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  botright lwindow
endf

" Find all occurrences of a pattern in all open files.
fun! lf_find#in_all_buffers(pattern)
  " Get the list of open files
  let l:files = map(filter(range(1, bufnr('$')), 'buflisted(v:val) && !empty(bufname(v:val))'), 'fnameescape(bufname(v:val))')
  cexpr [] " Clear quickfix list
  try
    silent noautocmd execute printf("vimgrepadd /%s/gj %s", a:pattern, join(l:files))
  catch /^Vim\%((\a\+)\)\=:E480/  " Pattern not found
    call lf_msg#warn("No match")
  endtry
  botright cwindow
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
  botright cwindow
  redraw!
endf

fun! s:get_ff_output(inpath, outpath, callback, channel, status)
  let l:output = filereadable(a:outpath) ? readfile(a:outpath) : []
  silent! call delete(a:outpath)
  silent! call delete(a:inpath)
  call function(a:callback)(l:output)
endf

for s:ff_bin in ['sk', 'fzf', 'fzy', 'selecta', 'pick', ''] " Sort according to your preference
  if executable(s:ff_bin)
    break
  endif
endfor

" Fuzzy filter a list and return a List of selected items.
" 'input' is either a shell command that sends its output, one item per line,
" to stdout, or a List of items to be filtered.
fun! lf_find#fuzzy(input, callback, prompt)
  if empty(s:ff_bin) " Fallback
    return zeef#open(type(a:input)) == 1 ? systemlist(a:input) : a:input, a:callback, a:prompt)
  endif

  let l:ff_cmds = {
        \ 'fzf':     "|fzf -m --height 15 --prompt '" .. a:prompt .. "> ' 2>/dev/tty",
        \ 'fzy':     "|fzy --lines=15 --prompt='" .. a:prompt .. "> ' 2>/dev/tty",
        \ 'pick':    "|pick -X",
        \ 'selecta': "|selecta 2>/dev/tty",
        \ 'sk':      "|sk -m --height 15 --prompt '" .. a:prompt .. "> '"
        \ }

  let l:ff_cmd = l:ff_cmds[s:ff_bin]

  if type(a:input) ==# 1 " v:t_string
    let l:inpath = ''
    let l:cmd = a:input .. l:ff_cmd
  else " Assume List
    let l:inpath = tempname()
    call writefile(a:input, l:inpath)
    let l:cmd  = 'cat ' .. fnameescape(l:inpath) .. l:ff_cmd
  endif

  if !has('gui_running') && executable('tput') && filereadable('/dev/tty')
    let l:output = systemlist(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; %s', &lines, l:cmd))
    redraw!
    silent! call delete(a:inpath)
    call function(a:callback)(l:output)
    return
  endif

  let l:outpath = tempname()
  let l:cmd ..= " >" .. fnameescape(l:outpath)

  if has('terminal')
    botright 15split
    call term_start([&shell, &shellcmdflag, l:cmd], {
          \ "term_name": a:prompt,
          \ "curwin": 1,
          \ "term_finish": "close",
          \ "exit_cb": function('s:get_ff_output', [l:inpath, l:outpath, a:callback])
          \ })
  else
   silent execute '!' .. l:cmd
   redraw!
   call s:get_ff_output(l:inpath, l:outpath, a:callback, -1, v:shell_error)
  endif
endf

" Fuzzy filter a list of paths and populate the arglist with the selected items.
fun! lf_find#fuzzy_arglist(input)
  call lf_find#fuzzy(a:input, 'zeef#set_arglist', 'Choose files')
endf

fun! lf_find#fuzzy_files(...) " ... is an optional directory
  let l:dir = (a:0 > 0 ? ' '.a:1 : ' .')
  call lf_find#fuzzy_arglist(executable('rg') ? 'rg --files' .. l:dir : 'find' .. l:dir .. ' -type f')
endf

