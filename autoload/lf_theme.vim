" Return the background color of the given highlight group, as a two-element
" array containing the cterm and the gui entry.
fun! lf_theme#bg(hl)
  return [synIDattr(synIDtrans(hlID(a:hl)), "bg", "cterm"), synIDattr(synIDtrans(hlID(a:hl)), "bg", "gui")]
endf

" Ditto, for the foreground color.
fun! lf_theme#fg(hl)
  return [synIDattr(synIDtrans(hlID(a:hl)), "fg", "cterm"), synIDattr(synIDtrans(hlID(a:hl)), "fg", "gui")]
endf

fun! lf_theme#contrast(delta)
  if !exists("g:colors_name") | return | endif
  if g:colors_name =~# "^solarized8"
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
  let l:theme = get(g:, "colors_name", "")
  if l:theme =~# "^seoul256-light"
    colorscheme seoul256
  elseif l:theme =~# "^seoul256"
    colorscheme seoul256-light
  elseif l:theme =~# "^Tomorrow-Night"
    colorscheme Tomorrow
  elseif l:theme =~# "^Tomorrow"
    colorscheme Tomorrow-Night-Eighties
  elseif l:theme =~# "dark"
    execute "colorscheme" substitute(g:colors_name, 'dark', 'light', '')
  elseif l:theme =~# "light"
    execute "colorscheme" substitute(g:colors_name, 'light', 'dark', '')
  else
    let g:lf_cached_mode = ""  " Force updating status line highlight groups
    let &background = (&background == 'dark') ? 'light' : 'dark'
  endif
endf

