fun! s:msg(mode, message)
  redraw
  echo "\r"
  execute 'echohl' a:mode
  echomsg a:message
  echohl None
endf

fun! lf_msg#notice(m)
  call s:msg('ModeMsg', a:m)
endf

fun! lf_msg#warn(m)
  call s:msg('WarningMsg', a:m)
endf

fun! lf_msg#err(m)
  call s:msg('Error', a:m)
endf

