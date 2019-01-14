" Send the output of a Vim command to a new scratch buffer.
"
" Example: :call lf_run#vim_cmd('digraphs')
fun! lf_run#vim_cmd(cmd)
  botright 10new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call append(0, split(execute(a:cmd), "\n"))
endf

" Synchronously run a non-interactive shell command and send its output to
" a new scratch buffer. By default, the command is run in the directory of the
" current buffer.
"
" cmd: a List whose first item is the command name and the remaining items are
" the command's arguments
" ...: a Dictionary with additional options:
"      'cwd': change to this directory before running the command
"      'pos': Vim command specifying where the output window should be opened.
fun! lf_run#cmd(cmd, ...) abort
  let l:opt = get(a:000, 0, {})
  if !has_key(l:opt, 'cwd')
    let l:opt['cwd'] = fnameescape(expand('%:p:h'))
  endif
  let l:cmd = join(map(a:cmd, 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'))
  execute get(l:opt, "pos", "botright") "new"
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  nnoremap <buffer> q <c-w>c
  execute 'lcd' l:opt['cwd']
  execute '%!' l:cmd
endf

if exists("*job_start")

  " Run a background job, connecting its stdout to a buffer called STDOUT and
  " its stderr to a buffer called STDERR (create or clear the buffers before
  " running the job). Optionally, invoke a callback when the job is done. This
  " is useful for stuff like TeX typesetting or any other command that does
  " not require user interaction.
  "
  " cmd: the command to be execute
  " ...: an optional Dictionary with any of the following keys:
  "      'cwd': specify the working directory (default: getcwd());
  "      'cb': an exit callback;
  "      'args': optional List of arguments for the callback;
  "      'fg': if set to 1, show the stdout buffer (default: 0).
  fun! lf_run#job(cmd, ...)
    for l:buf in ['^STDOUT$', '^STDERR$']
      call lf_buffer#clear(l:buf)
    endfor
    let l:opt = get(a:000, 0, {})
    let l:job = job_start(a:cmd, {
          \ "cwd"     : get(l:opt, "cwd", getcwd()),
          \ "close_cb": "lf_run#close_cb",
          \ "exit_cb" : function(get(l:opt, "cb", "lf_run#callback"),
          \                      get(l:opt, 'args', [bufnr('%')])),
          \ "in_io"   : "null",
          \ "out_io"  : "buffer",
          \ "out_name": "STDOUT",
          \ "err_io"  : "buffer",
          \ "err_name": "STDERR" })
    if get(l:opt, 'fg', 0) && bufwinnr(ch_getbufnr(l:job, "out")) < 0 " If the buffer is not visible
      execute "botright 10split +buffer".ch_getbufnr(l:job, "out")
      nnoremap <buffer> q <c-w>c
      wincmd p
    endif
    return l:job
  endf

  fun! lf_run#close_cb(channel)
    call job_status(ch_getjob(a:channel)) " Trigger exit_cb's callback
  endf

  fun! lf_run#callback(bufnr, job, status)
    if a:status == 0
      call lf_msg#notice("Success!")
    else
      call lf_msg#err("Job failed.")
    endif
  endf

else

  fun! lf_run#job(cmd, ...)
    call lf_msg#err('Function not implemented.')
  endf

endif

