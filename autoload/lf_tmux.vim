let s:tmux_directions = {'h':'L', 'j':'D', 'k':'U', 'l':'R'}

fun! lf_tmux#navigate(dir)
  let l:winnr = winnr()
  execute 'wincmd' a:dir
  if winnr() ==# l:winnr
    call system("tmux select-pane -".s:tmux_directions[a:dir])
  endif
endf
