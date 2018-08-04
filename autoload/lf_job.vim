if exists("*job_start")

  fun! lf_job#start(cwd, cmd, ...) " Third parameter is an optional callback
    for l:buf in ['^STDOUT$', '^STDERR$']
      call lf_buffer#clear(l:buf)
    endfor
    return job_start(a:cmd, {
          \ "cwd": a:cwd,
          \ "close_cb": "lf_job#close_cb",
          \ "exit_cb": function(get(a:000, 0, "lf_job#callback"), get(a:000, 1, [bufnr('%')])),
          \ "in_io": "null", "out_io": "buffer", "out_name": "STDOUT",
          \ "err_io": "buffer", "err_name": "STDERR" })
  endf

  fun! lf_job#close_cb(channel)
    call job_status(ch_getjob(a:channel)) " Trigger exit_cb's callback
  endf

  fun! lf_job#callback(bufnr, job, status)
    if a:status == 0
      call lf_msg#notice("Success!")
    else
      call lf_msg#err("Job failed.")
    endif
  endf

  if has('terminal') " Vim 8 or later, MacVim

    " Execute an external command and send its output to a new buffer.
    fun! lf_job#to_buffer(cmd) " FIXME: escaping
      execute 'botright terminal' (type(a:cmd) == v:t_string ? a:cmd : join(a:cmd, ' '))
    endf

  else

    fun! lf_job#to_buffer(cmd)
      let l:job = lf_job#start(getcwd(), map(
            \ type(a:cmd) == type("") ? split(a:cmd) : a:cmd,
            \ 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : expand(v:val)'
            \ ))
      if bufwinnr(ch_getbufnr(l:job, "out")) < 0 " If the buffer is not visible
        execute "botright split +buffer".ch_getbufnr(l:job, "out")
        wincmd p
      endif
    endf

  endif

else " NeoVim, older Vim

  fun! lf_job#to_buffer(cmd)
    call lf_legacy#job#to_buffer(a:cmd)
  endf

  fun! lf_job#start(cwd, cmd, ...)
    call lf_legacy#job#start(a:cwd, a:cmd, get(a:000, 1, 'lf_legacy#job#callback'))
  endf

endif
