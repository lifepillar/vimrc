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
    silent noautocmd execute "vimgrepadd /" . a:pattern . "/gj" join(map(l:files, 'fnameescape(v:val)'))
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

" Filter a list and return a List of selected items.
" 'input' is either a shell command that sends its output, one item per line,
" to stdout, or a List of items to be filtered.
fun! lf_find#fuzzy(input, callback, prompt)
  if empty(s:ff_bin) " Fallback
    call lf_find#interactively(a:input, a:callback, a:prompt)
    return
  endif

  let l:ff_cmds = {
        \ 'fzf':     "|fzf -m --height 15 --prompt '".a:prompt."> ' 2>/dev/tty",
        \ 'fzy':     "|fzy --lines=15 --prompt='".a:prompt."> ' 2>/dev/tty",
        \ 'pick':    "|pick -X",
        \ 'selecta': "|selecta 2>/dev/tty",
        \ 'sk':      "|sk -m --height 15 --prompt '".a:prompt."> '"
        \ }

  let l:ff_cmd = l:ff_cmds[s:ff_bin]

  if type(a:input) ==# v:t_string
    let l:inpath = ''
    let l:cmd = a:input . l:ff_cmd
  else " Assume List
    let l:inpath = tempname()
    call writefile(a:input, l:inpath)
    let l:cmd  = 'cat '.fnameescape(l:inpath) . l:ff_cmd
  endif

  if !has('gui_running') && executable('tput') && filereadable('/dev/tty')
    let l:output = systemlist(printf('tput cup %d >/dev/tty; tput cnorm >/dev/tty; ' . l:cmd, &lines))
    redraw!
    silent! call delete(a:inpath)
    call function(a:callback)(l:output)
    return
  endif

  let l:outpath = tempname()
  let l:cmd .= " >" . fnameescape(l:outpath)

  if has('terminal')
    botright 15split
    call term_start([&shell, &shellcmdflag, l:cmd], {
          \ "term_name": a:prompt,
          \ "curwin": 1,
          \ "term_finish": "close",
          \ "exit_cb": function('s:get_ff_output', [l:inpath, l:outpath, a:callback])
          \ })
  else
   silent execute '!' . l:cmd
   redraw!
   call s:get_ff_output(l:inpath, l:outpath, a:callback, -1, v:shell_error)
  endif
endf

fun! s:set_arglist(paths)
  if empty(a:paths) | return | endif
  execute "args" join(map(a:paths, 'fnameescape(v:val)'))
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

" Interactively filter a list of items as you type, and execute an action on
" the selected item. Sort of a poor man's CtrlP.
"
" input:    either a shell command that sends its output, one item per line,
"           to stdout, or a List of items to be filtered.
" callback: the function to be called on the filtered item. The function must
"           take one argument (a List).
fun! lf_find#interactively(input, callback, prompt) abort
  let l:cursor = '_' " Cursor displayed at the prompt
  let l:filter = ''  " Text used to filter the list
  let l:undoseq = [] " Stack to tell whether to undo when pressing backspace (1 = undo, 0 = do not undo)
  let l:seq_new = 0  " Current position in the undo tree
  botright 10new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ nonumber\ norelativenumber\ noswapfile\ nowrap
  if type(a:input) ==# v:t_string
    let l:input = systemlist(a:input)
    call setline(1, l:input)
  else " Assume List
    call setline(1, a:input)
  endif
  setlocal cursorline
  " Hide cursor
  let l:t_ve = &t_ve
  set t_ve=
  redraw
  echo a:prompt l:cursor
  try
    while 1
      let ch = getchar()
      if ch ==# "\<bs>" " Backspace
        let l:filter = l:filter[:-2]
        let l:undo = empty(l:undoseq) ? 0 : remove(l:undoseq, -1)
        if l:undo
          silent norm u
        endif
      elseif ch >=# 0x20 " Printable character
        let l:filter .= nr2char(ch)
        let l:seq_old = l:seq_new
        execute 'silent g!:' . escape(l:filter, ':') . ':norm dd'
        let l:seq_new = get(undotree(), 'seq_cur', 0)
        call add(l:undoseq, l:seq_new != l:seq_old) " seq_new != seq_old iff buffer has changed
      elseif ch ==# 0x1B " Escape
        bwipe
        return
      elseif ch ==# 0x0D " Enter
        let l:result = [getline('.')]
        bwipe
        call function(a:callback)(l:result)
        return
      elseif ch ==# 0x0B " CTRL-K
        norm k
      elseif index([0x02, 0x04, 0x06, 0x0A, 0x15], ch) >= 0 " CTRL-B, CTRL-D, CTRL-F, CTRL-J, CTRL-U
        execute "normal" nr2char(ch)
      endif
      redraw
      echo a:prompt l:filter.l:cursor
    endwhile
  catch /^Vim:Interrupt$/  " CTRL-C
    bwipe
  finally
    " Restore cursor
    let &t_ve = l:t_ve
    redraw
    echo "\r"
  endtry
endf

fun! lf_find#colorscheme()
  let l:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , 'fnamemodify(v:val, ":t:r")')
  let l:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , 'fnamemodify(v:val, ":t:r")')
  call lf_find#interactively(l:colors, 's:set_colorscheme', 'Choose colorscheme')
endf
