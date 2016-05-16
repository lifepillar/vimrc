fun! lf_theme#contrast(delta)
  if g:colors_name =~# "^solarized8"
    let l:schemes = map(["_low", "_flat", "", "_high"], '"solarized8_".(&background).v:val')
    exe "colorscheme" l:schemes[(a:delta+index(l:schemes, g:colors_name)) % 4]
  endif
endf

