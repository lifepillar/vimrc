fun! lf_theme#contrast(delta)
  if !exists("g:colors_name") | return | endif
  if g:colors_name ==# 'wwdc17'
    let g:wwdc17_high_contrast = 1 - get(g:, 'wwdc17_high_contrast', 0)
    colorscheme wwdc17
  elseif g:colors_name =~# "^solarized8"
    let l:schemes = map(["_low", "_flat", "", "_high"], '"solarized8_".(&background).v:val')
    execute "colorscheme" l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
  elseif g:colors_name =~# "^gruvbox"
    let l:schemes = ["hard", "medium", "soft"]
    execute 'let' ((&background == 'dark') ? 'g:gruvbox_contrast_dark' : 'g:gruvbox_contrast_light') '='
          \ 'get(l:schemes, ((a:delta+index(l:schemes, (&background == "dark") ? g:gruvbox_contrast_dark : g:gruvbox_contrast_light)) % 3 + 3) % 3)'
    colorscheme gruvbox
  elseif g:colors_name =~# "^seoul256-light"
    let g:seoul256_light_background = ((a:delta+(g:seoul256_light_background-252)) % 5 + 5) % 5 + 252  " [252-256]
    colorscheme seoul256-light
  elseif g:colors_name =~# "^seoul256"
    let g:seoul256_background = ((a:delta+(g:seoul256_background-233)) % 7 + 7) % 7 + 233  " [233-239]
    colorscheme seoul256
  elseif g:colors_name =~# "^pencil"
    let g:pencil_higher_contrast_ui = 1 - g:pencil_higher_contrast_ui
    colorscheme pencil
  endif
endf

fun! lf_theme#toggle_bg_color()
  if empty(get(g:, "colors_name", "")) | return | endif
  if g:colors_name =~# 'wwdc16'
    colorscheme wwdc17
  elseif g:colors_name =~# 'wwdc17'
    colorscheme wwdc16
  elseif g:colors_name =~# "^seoul256-light"
    colorscheme seoul256
  elseif g:colors_name =~# "^seoul256"
    colorscheme seoul256-light
  elseif g:colors_name =~# "^Tomorrow-Night"
    colorscheme Tomorrow
  elseif g:colors_name =~# "^Tomorrow"
    colorscheme Tomorrow-Night-Eighties
  elseif g:colors_name =~? "dark"
    execute "colorscheme" substitute(g:colors_name, '\(d\)ark', '\=submatch(1)==#"D"?"Light":"light"', '')
  elseif g:colors_name =~? "light"
    execute "colorscheme" substitute(g:colors_name, '\(l\)ight', '\=submatch(1)==#"L"?"Dark":"dark"', '')
  else
    let &background = (&background == 'dark') ? 'light' : 'dark'
    execute "colorscheme" g:colors_name
  endif
endf
