fun! s:msg(mode, message)
  redraw
  echo "\r"
  execute 'echohl' a:mode
  echomsg a:message
  echohl None
endf

fun! local#msg#notice(m)
  call s:msg('ModeMsg', a:m)
endf

fun! local#msg#warn(m)
  call s:msg('WarningMsg', a:m)
endf

fun! local#msg#err(m)
  call s:msg('Error', a:m)
endf

