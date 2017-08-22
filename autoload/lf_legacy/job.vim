fun! lf_legacy#job#to_buffer(cmd)
  let l:cmd = join(map(
        \ type(a:cmd) == type("") ? split(a:cmd) : a:cmd,
        \ 'v:val !~# "\\v^[%#<]" || expand(v:val) == "" ? v:val : shellescape(expand(v:val))'
        \ ))
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute '%!'. l:cmd
  setlocal nomodifiable
  wincmd p
endf

if has("nvim")

  fun! lf_legacy#job#start(cmd, ...) " Second parameter is an optional callback
    let l:callback = get(a:000, 0, 'lf_legacy#job#callback')
    return jobstart(a:cmd, { "on_exit": l:callback, "lf_data": get(a:000, 1, [bufnr("%")]) })
  endf

  fun! lf_legacy#job#callback(job_id, data, event)
    if a:event == 'exit'
      if a:data == 0 " 2nd arg is exit status when event is 'exit'
        call lf_msg#notice("Success!")
      else
        call lf_msg#err("Job failed.")
      endif
    endif
  endf

else " Old Vim

  fun! lf_legacy#job#start(cmd, ...)
    call lf_msg#err("Function non implemented")
    return
  endf

endif
