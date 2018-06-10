" Find all occurrences of a pattern in a file.
fun! lf_find#in_buffer(pattern)
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
fun! lf_find#in_all_buffers(pattern)
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

fun! s:filter_close(bufnr)
  wincmd p
  execute "bwipe" a:bufnr
  redraw
  echo "\r"
endf

" Interactively filter a list of items as you type, and execute an action on
" the selected item. Sort of a poor man's CtrlP.
"
" input:    either a shell command that sends its output, one item per line,
"           to stdout, or a List of items to be filtered.
fun! lf_find#interactively(input, callback, prompt) abort
  let l:prompt = a:prompt . '>'
  let l:filter = ''  " Text used to filter the list
  let l:undoseq = [] " Stack to tell whether to undo when pressing backspace (1 = undo, 0 = do not undo)
  botright 10new +setlocal\ buftype=nofile\ bufhidden=wipe\ nobuflisted\ nonumber\ norelativenumber\ noswapfile\ nowrap
  let l:cur_buf = bufnr('%') " Store current buffer number
  if type(a:input) ==# v:t_string
    let l:input = systemlist(a:input)
    call setline(1, l:input)
  else " Assume List
    call setline(1, a:input)
  endif
  setlocal cursorline
  redraw
  echo l:prompt . ' '
  while 1
    let l:error = 0 " Set to 1 when pattern is invalid
    try
      let ch = getchar()
    catch /^Vim:Interrupt$/  " CTRL-C
      return s:filter_close(l:cur_buf)
    endtry
    if ch ==# "\<bs>" " Backspace
      let l:filter = l:filter[:-2]
      let l:undo = empty(l:undoseq) ? 0 : remove(l:undoseq, -1)
      if l:undo
        silent norm u
      endif
    elseif ch >=# 0x20 " Printable character
      let l:filter .= nr2char(ch)
      let l:seq_old = get(undotree(), 'seq_cur', 0)
      try
        execute 'silent g!:\m' . escape(l:filter, '~\[:') . ':norm "_dd'
      catch /^Vim\%((\a\+)\)\=:E/
        let l:error = 1
      endtry
      let l:seq_new = get(undotree(), 'seq_cur', 0)
      call add(l:undoseq, l:seq_new != l:seq_old) " seq_new != seq_old iff buffer has changed
    elseif ch ==# 0x1B " Escape
      return s:filter_close(l:cur_buf)
    elseif ch ==# 0x0D " Enter
      let l:result = [getline('.')]
      call s:filter_close(l:cur_buf)
      if !empty(l:result[0])
        call function(a:callback)(l:result)
      endif
      return
    elseif ch ==# 0x0C " CTRL-L (clear)
      call setline(1, type(a:input) ==# v:t_string ? l:input : a:input)
      let l:undoseq = []
      let l:filter = ''
      redraw
    elseif ch ==# 0x0B " CTRL-K
      norm k
    elseif index([0x02, 0x04, 0x06, 0x0A, 0x15], ch) >= 0 " CTRL-B, CTRL-D, CTRL-F, CTRL-J, CTRL-U
      execute "normal" nr2char(ch)
    endif
    redraw
    echo (l:error ? '[Invalid pattern] ' : '').l:prompt l:filter
  endwhile
endf


"
" Find file
"
fun! s:set_arglist(paths)
  if empty(a:paths) | return | endif
  execute "args" join(map(a:paths, 'fnameescape(v:val)'))
endf

" Filter a list of paths and populate the arglist with the selected items.
fun! lf_find#arglist(input_cmd)
  call lf_find#interactively(a:input_cmd, 's:set_arglist', 'Choose file')
endf

" Fuzzy filter a list of paths and populate the arglist with the selected items.
fun! lf_find#arglist_fuzzy(input_cmd)
  call lf_find#fuzzy(a:input_cmd, 's:set_arglist', 'Choose files')
endf

fun! lf_find#file(...) " ... is an optional directory
  let l:dir = (a:0 > 0 ? ' '.a:1 : ' .')
  call lf_find#arglist_fuzzy(executable('rg') ? 'rg --files'.l:dir : 'find'.l:dir.' -type f')
endf

"
" Find buffer
"
fun! s:switch_to_buffer(buffers)
  execute "buffer" split(a:buffers[0], '\s\+')[0]
endf


" When 'unlisted' is set to 1, show also unlisted buffers
fun! lf_find#buffer(unlisted)
  let l:buffers = split(execute('ls'.(a:unlisted ? '!' : '')), "\n")
  call lf_find#interactively(l:buffers, 's:switch_to_buffer', 'Switch buffer')
endf

"
" Find tag in current buffer
"
fun! s:jump_to_tag(tags)
  let [l:tag, l:bufname, l:line] = split(a:tags[0], '\s\+')
  execute "buffer" "+".l:line l:bufname
endf

fun! lf_find#buffer_tag()
  call lf_find#interactively(lf_tags#file_tags('%', &ft), 's:jump_to_tag', 'Choose tag')
endf

"
" Find in quickfix/location list
"
fun! s:jump_to_qf_entry(items)
  execute "crewind" matchstr(a:items[0], '^\s*\d\+', '')
endf

fun! s:jump_to_loclist_entry(items)
  execute "lrewind" matchstr(a:items[0], '^\s*\d\+', '')
endf

fun! lf_find#in_qflist()
  let l:qflist = getqflist()
  if empty(l:qflist)
    call lf_msg#warn('Quickfix list is empty')
    return
  endif
  call lf_find#interactively(split(execute('clist'), "\n"), 's:jump_to_qf_entry', 'Filter quickfix entry')
endf

fun! lf_find#in_loclist(winnr)
  let l:loclist = getloclist(a:winnr)
  if empty(l:loclist)
    call lf_msg#warn('Location list is empty')
    return
  endif
  call lf_find#interactively(split(execute('llist'), "\n"), 's:jump_to_loclist_entry', 'Filter loclist entry')
endf

"
" Find colorscheme
"
fun! s:set_colorscheme(colors)
  execute "colorscheme" a:colors[0]
endf

fun! lf_find#colorscheme()
  let l:colors = map(globpath(&runtimepath, "colors/*.vim", v:false, v:true) , 'fnamemodify(v:val, ":t:r")')
  let l:colors += map(globpath(&packpath, "pack/*/{opt,start}/*/colors/*.vim", v:false, v:true) , 'fnamemodify(v:val, ":t:r")')
  call lf_find#interactively(l:colors, 's:set_colorscheme', 'Choose colorscheme')
endf
