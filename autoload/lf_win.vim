fun! lf_win#zoom_toggle() abort
  if winnr('$') == 1 | return | endif " Only one window

  if exists('t:zoom_restore')
    execute t:zoom_restore
    unlet t:zoom_restore
  else
    let t:zoom_restore = winrestcmd()
    wincmd |
    wincmd _
  endif
endfun

