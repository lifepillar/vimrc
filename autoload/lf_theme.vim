" Return the background color of the given highlight group, as a two-element
" array containing the cterm and the gui entry.
fun! lf_theme#bg(hl)
  return [synIDattr(synIDtrans(hlID(a:hl)), "bg", "cterm"), synIDattr(synIDtrans(hlID(a:hl)), "bg", "gui")]
endf

" Ditto, for the foreground color.
fun! lf_theme#fg(hl)
  return [synIDattr(synIDtrans(hlID(a:hl)), "fg", "cterm"), synIDattr(synIDtrans(hlID(a:hl)), "fg", "gui")]
endf

" Print information about the highlight group at the cursor position.
" See: http://vim.wikia.com/wiki/VimTip99 and hilinks.vim script.
fun! lf_theme#hi_info()
  let trans = synIDattr(synID(line("."), col("."), v:false), "name")
  let synid = synID(line("."), col("."), v:true)
  let higrp = synIDattr(synid, "name")
  let synid = synIDtrans(synid)
  let logrp = synIDattr(synid, "name")
  let fgcol = [synIDattr(synid, "fg", "cterm"), synIDattr(synid, "fg", "gui")]
  let bgcol = [synIDattr(synid, "bg", "cterm"), synIDattr(synid, "bg", "gui")]
  try " The following may raise an error, e.g., if CtrlP is opened while this is active
    execute "hi!" "LFHiInfoFg" "ctermbg=".(empty(fgcol[0])?"NONE":fgcol[0]) "guibg=".(empty(fgcol[1])?"NONE":fgcol[1])
    execute "hi!" "LFHiInfoBg" "ctermbg=".(empty(bgcol[0])?"NONE":bgcol[0]) "guibg=".(empty(bgcol[1])?"NONE":bgcol[1])
  catch /^Vim\%((\a\+)\)\=:E254/ " Cannot allocate color
    hi clear LFHiInfoFg
    hi clear LFHiInfoBg
  endtry
  echo join(map(reverse(synstack(line("."), col("."))), {i,v -> synIDattr(v, "name")}), " ⊂ ")
  execute "echohl" logrp | echon " xxx " | echohl None
  echon (higrp != trans ? "T:".trans." → ".higrp : higrp) . (higrp != logrp ? " → ".logrp : "")." "
  echohl LFHiInfoFg | echon "  " | echohl None
  echon " fg=".join(fgcol, "/")." "
  echohl LFHiInfoBg | echon "  " | echohl None
  echon " bg=".join(bgcol, "/")
endf

fun! lf_theme#toggle_hi_info()
  if exists("#lf_hi_info")
    autocmd! lf_hi_info
    augroup! lf_hi_info
  else
    augroup lf_hi_info
      autocmd CursorMoved * call lf_theme#hi_info()
    augroup END
  endif
endf

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
