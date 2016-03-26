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

" Run a command in the background (if possible), invoking a callback function
" when the job is over. The command is executed from the current directory.
" The first argument should be a List. The second (optional) argument is
" a callback function.
"
" The program executable should be the first element of the list, followed by
" zero or more arguments (things like '&&', setting environment variables,
" etc..., are not allowed).
"
" Note that Vim and NeoVim use different calling conventions for the callback
" function. See `:h job_start()` and `:h jobstart()`, respectively.
if has("gui_running") && has("clientserver") " MacVim
  fun! lf_shell#async_run(cmd, ...)
    let l:callback = a:0 > 0 ? a:1 : 'lf_shell#callback'
    let l:callback = substitute(l:callback, '#', '\\#', 'g')
    let l:cmd = '('
    let l:cmd .= type(a:cmd) == type([]) ? join(map(a:cmd, 'shellescape(v:val)')) : a:cmd
    let l:cmd .= ' >/dev/null 2>&1;mvim --remote-expr "' . l:callback . '(''MacVim job'',$?)")&'
    silent exec '!' . l:cmd
  endf
elseif has("nvim") " NeoVim
  fun! lf_shell#async_run(cmd, ...)
    let l:callback = a:0 > 0 ? a:1 : 'lf_shell#callback'
    " Without calling it explicitly before invoking jobstart(),
    " NeoVim may not find a callback function defined in autoload:
    execute 'call' l:callback . "(0,0,'load')"
    call jobstart(a:cmd, {"on_exit": l:callback})
  endf
elseif exists("*job_start") " Vim
  fun! lf_shell#async_run(cmd, ...)
    let l:callback = a:0 > 0 ? a:1 : 'lf_shell#callback'
    call job_start(a:cmd, {"exit_cb": l:callback})
  endf
else " Vim (old version)
  fun! lf_shell#async_run(cmd, ...)
    let l:callback = a:0 > 0 ? a:1 : 'lf_shell#callback'
    let l:cmd = type(a:cmd) == type([]) ? join(a:cmd) : a:cmd
    execute "!" . l:cmd
    execute 'call '.l:callback.'("Synchronous job",'.v:shell_error.')'
  endf
endif

if has("nvim")
  fun! lf_shell#callback(job_id, data, event)
    if a:event == 'exit'
      if a:data == 0 " 2nd arg is exit status when event is 'exit'
        call lf_msg#notice("Success!")
      else
        call lf_msg#err("Job failed.")
      endif
    endif
  endf
else
  fun! lf_shell#callback(job, status)
    if a:status == 0
      call lf_msg#notice("Success!")
    else
      call lf_msg#err("Job failed.")
    endif
  endf
endif

